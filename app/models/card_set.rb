class CardSet
  include Mongoid::Document
  include Mongoid::Slug

  field :name, type: String
  slug :name
  field :code, type: String # The code name of the set
  field :gathererCode, type: String # The code that Gatherer uses for the set. Only present if different than 'code'
  field :releaseDate, type: Date
  field :type, type: String # Type of set. One of: "core", "expansion"
  field :block, type: String

  has_many :cards

  index(code: 1)
  index(releaseDate: 1)

  USED_TYPES = %w(core expansion)
  SKIP = %w(TSB)
  STANDARD = %w(XLN RIX DOM M19 GRN RNA WAR) # http://whatsinstandard.com/

  # this is used for the header menu, and almost always available
  def self.history
    all.in(type: USED_TYPES).not_in(code: SKIP).order_by([[:releaseDate, :asc]])
  end

  def keywords
    cards.map(&:keywords).flatten.uniq
  end
end
