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
  field :colorIdentity, type: Array
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

  EVERGREEN_WORDS = %w(
    activate attach cast counter create deathtouch defender
    destroy draw discard double strike enchant equip exchange
    exile fight first strike flash flying haste hexproof
    indestructible lifelink menace play prowess reach reveal
    sacrifice scry search shuffle tap untap trample vigilance
    ante banding bury fear shroud intimidate landwalk protection
    regenerate
  )

  def self.rarity_colors
    [
      '#b02911',
      '#83703d',
      '#474e51',
      '#000000'
    ]
  end

  def self.color_aliases(string)
    case string.downcase
    when 'w', 'plains', 'white' then 'W'
    when 'u', 'island', 'blue'  then 'U'
    when 'b', 'swamp', 'black'  then 'B'
    when 'g', 'forest', 'green' then 'G'
    when 'r', 'mountain', 'red' then 'R'
    when 'c', 'colorless'       then 'C'
    end
  end

  def colors
    colors = [colorIdentity]
    colors += all_types.map{ |c| Card.color_aliases(c) }
    colors += manaCost.scan(/[A-Z]*/).reject(&:blank?) if manaCost
    colors += text.scan(/{\w|\w}/).map{ |t| t.delete('{}T0123456789') }.uniq if text
    colors = colors.flatten.compact.uniq
  end

  def keywords
    return [] unless text
    text.split.map(&:downcase) & EVERGREEN_WORDS
  end

  def options
    options = [colors, all_types, set_code, rarity, keywords]
    options += [related_cards.map(&:colors), related_cards.map(&:all_types), related_cards.map(&:keywords)]
    options.flatten.map(&:presence).compact.map{ |o| o.downcase.strip }.uniq
  end

  def related_cards
    return [] unless alternate_info?
    card_set.cards.where(:name.in => names)
  end

  def all_types
    [types, supertypes, subtypes].flatten.compact
  end

  def front
    "#{Rails.configuration.image_host}/#{set_name.downcase}/#{imageName}.jpg"
  end

  def default_back
    "#{Rails.configuration.image_host}/back.jpg"
  end

  def back
    return default_back unless alternate_info?
    return default_back if %w(split flip aftermath).include? layout

    face = card_set.cards.find_by(name: names[-1])
    meld_side = names.find_index(name) == 0 ? ' bottom' : ' top' if layout == 'meld'
    "#{Rails.configuration.image_host}/#{set_name.downcase}/#{face.imageName}#{meld_side}.jpg"
  end

  def alternate_info?
    # normal, split, flip, double-faced, token, plane, scheme,
    # phenomenon, leveler, vanguard, meld, aftermath
    names.try(:many?)
  end

end
