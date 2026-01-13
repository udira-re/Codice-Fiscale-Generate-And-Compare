require 'json'

# Load Italian municipalities
comuni = JSON.parse(File.read('app/data/comuni.json'))

italian_municipalities = comuni.map do |c|
  {
    "name" => c["nome"].upcase,        # Name in uppercase
    "code" => c["codiceCatastale"],    # Codice catastale
    "province" => c["sigla"]           # Province sigla
  }
end

# Save to a temporary JSON to check
File.write('app/data/italian_municipalities.json', JSON.pretty_generate(italian_municipalities))
puts "Saved Italian municipalities JSON!"
