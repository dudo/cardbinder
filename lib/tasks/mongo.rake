namespace :mongo do

  def import_mtg_set(file)
    doc = JSON.parse( IO.read(file) ).with_indifferent_access
    set = CardSet.where(code: doc['code']).first_or_initialize
    set.name ||= doc['name']
    set.gathererCode = doc['gathererCode']
    set.releaseDate = doc['releaseDate']
    set.type = doc['type']
    set.block = doc['block']
    set.save

    doc['cards'].each do |card|
      c = set.cards.find_or_initialize_by(name: card['name'], number: card['number'])
      c.set_name ||= set.name
      c.set_code ||= set.code
      c.imageName ||= card['imageName']
      c.layout = card['layout']
      c.names = card['names']
      c.manaCost = card['manaCost']
      c.cmc = card['cmc']
      c.colors = card['colors']
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
  end

  desc "Imports all or the specified JSON file to the Mongo collection(s)"
  task :import_directory, [:directory] => :environment do |task, args|
    raise "Must include a directory" unless args.directory
    Dir.glob("#{args.directory}/*.json") do |o|
      import_mtg_set(o)
      puts "Imported #{o.to_s}"
    end
  end

  desc "Imports a specified JSON file to the Mongo collection(s)"
  task :import_file, [:file] => :environment do |task, args|
    raise "Must include a file" unless args.file
    import_mtg_set(args.file)
    puts "Imported #{args.file.to_s}"
  end
end