class Card
  include Mongoid::Document
  include Mongoid::Slug
  field :set_name, type: String # Denormalizing this for querying
  field :set_code, type: String # Denormalizing this for querying
  field :layout, type: String # The card layout. Possible values: normal, split, flip, double-faced, token, plane, scheme, phenomenon, leveler, vanguard
  field :name, type: String # The card name. For split, double-faced and flip cards, just the name of one side of the card. Basically each 'sub-card' has it's own record.
  field :imageName, type: String
  field :names, type: Array # Only used for split, flip and dual cards. Will contain all the names on this card, front or back.
  field :manaCost, type: String
  field :cmc, type: Integer # converted mana cost
  field :colors, type: Array
  field :type, type: String # This is the type you would see on the card if printed today. Note: The dash is a UTF8 'long dash' as per the MTG rules
  field :supertypes, type: Array
  field :types, type: Array
  field :subtypes, type: Array
  field :rarity, type: String # Possible values: Common, Uncommon, Rare, Mythic Rare, Special
  field :text, type: String
  field :flavor, type: String
  field :artist, type: String
  field :number, type: String # The card number. This is printed at the bottom-center of the card in small text. This is a string, not an integer, because some cards have letters in their numbers.
  field :multiverseid, type: Integer # The multiverseid of the card on Wizard's Gatherer web page.
  field :variations, type: Array # If a card has alternate art (for example, 4 different Forests, or the 2 Brothers Yamazaki) then each other variation's multiverseid will be listed here, NOT including the current card's multiverseid.

  belongs_to :card_set
  has_and_belongs_to_many :users

  index({name: 1})
  index({set_code: 1})
  index({number: 1})
  index({colors: 1})

  slug :name

  # this is used for the header menu, and almost always available
  def self.sets
    CardSet.in(type: %w(core expansion)).not_in(code: CardSet::DONT_HAVE_PICS).order_by([[:releaseDate, :asc]])
  end

  def self.aliases(a)
    case a.downcase
    when 'w', 'plains', 'white' then 'W'
    when 'u', 'island', 'blue'  then 'U'
    when 'b', 'swamp', 'black'  then 'B'
    when 'g', 'forest', 'green' then 'G'
    when 'r', 'mountain', 'red' then 'R'
    end
  end

  def colors
    colors = []
    colors += self.subtypes.map{ |c| Card.aliases(c) } if self.subtypes && self.types.map(&:downcase).include?('land')
    colors += self.manaCost.scan(/[A-Z]*/).reject(&:blank?) if self.manaCost
    colors += self.text.scan(/{\w|\w}/).map{|t| t.delete('{}T0123456789')}.uniq if self.text
    colors = colors.uniq
  end

  def options
    self.colors + self.types.map(&:downcase) + [self.set_code]
  end

end