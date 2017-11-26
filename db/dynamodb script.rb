require 'oj'
require "aws-sdk-core"
require 'byebug'

dynamodb = Aws::DynamoDB::Client.new(
  region: "us-east-1",
  access_key_id: 'asdf',
  secret_access_key: 'asdf'
)

Dir.glob('/Users/dudo/Downloads/*.json') do |file|
  hash = Oj.load(File.read(file))
  next unless %w(core expansion).include? hash['type']

  hash.delete('border')
  hash.delete('oldCode')
  hash.delete('gathererCode')
  hash.delete('magicCardsInfoCode')
  hash.delete('onlineOnly')
  hash.delete('booster')
  hash.delete('translations')
  hash.delete('mkm_name')
  hash.delete('mkm_id')

  hash['cards'].each do |card|
    card.delete('watermark')
    card.delete('border')
    card.delete('hand')
    card.delete('life')
    card.delete('reserved')
    card.delete('foreignNames')
    card.delete('artist')
    card.delete('power')
    card.delete('toughness')
    card.delete('loyalty')
    card.delete('printings')
    card.delete('originalText')
    card.delete('originalType')
    card.delete('legalities')
    card.delete('source')
    card.delete('timeshifted')
    card.delete('starter')
  end

  begin
    result = dynamodb.put_item(
      {
        table_name: "magic_the_gathering",
        item: hash
      }
    )
    puts "Added item: #{hash['name']}"
  rescue  Aws::DynamoDB::Errors::ServiceError => error
    puts "Unable to add item:"
    puts "#{error.message}"
  end
end
