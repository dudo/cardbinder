namespace :mongo do

  def import_mtg_set(doc)
    return unless %w(core expansion).include?(doc['type'])

    set = CardSet.where(code: doc['code']).first_or_initialize
    set.name ||= doc['name']
    set.gathererCode = doc['gathererCode'] || doc['magicCardsInfoCode']
    set.releaseDate = doc['releaseDate']
    set.type = doc['type']
    set.block = doc['block']
    set.save

    doc['cards'].each do |card|
      c = set.cards.where(name: card['name'], number: card['number']).first_or_initialize
      c.set_code = set.code
      c.set_name = set.name
      c.imageName = card['imageName']
      c.layout = card['layout']
      c.names = card['names']
      c.manaCost = card['manaCost']
      c.cmc = card['cmc']
      c.colors = card['colors']
      c.colorIdentity = card['colorIdentity']
      c.type = card['type']
      c.supertypes = card['supertypes']
      c.types = card['types']
      c.subtypes = card['subtypes']
      c.rarity = card['rarity']
      c.text = card['text']
      c.flavor = card['flavor']
      c.artist = card['artist']
      c.multiverseid = card['multiverseid']
      c.variations = card['variations']
      c.save
    end
    puts "Successfully Imported #{set.name}"
  end

  def all_sets
  end

  desc "Imports all or the specified JSON file to the Mongo collection(s)"
  task :import_directory, [:directory] => :environment do |task, args|
    raise "Must include a directory" unless args.directory
    Dir.glob("#{args.directory}/*.json") do |o|
      set = JSON.parse( IO.read(o) ).with_indifferent_access
      import_mtg_set(set)
    end
  end

  desc "Imports a specified JSON file to the Mongo collection(s)"
  task :import_file, [:file] => :environment do |task, args|
    raise "Must include a file" unless args.file
    import_mtg_set(JSON.parse( IO.read(args.file) ).with_indifferent_access)
  end

  desc "Imports single File containing all Sets to the Mongo collections"
  task :import_all_cards => :environment do |task, args|
    JSON.parse( IO.read('AllSets.json') ).with_indifferent_access.each do |name, set|
      import_mtg_set(set)
    end
  end
end
