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

end


