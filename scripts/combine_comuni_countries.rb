require 'json'

# Load Italian municipalities
italian = JSON.parse(File.read('app/data/italian_municipalities.json'))

# Load foreign countries
foreign = JSON.parse(File.read('app/data/countries.json'))

# Combine
combined = italian + foreign

# Save final JSON
File.write('app/data/comuni_e_stati.json', JSON.pretty_generate(combined))
puts "Saved combined JSON with Italian municipalities and foreign countries!"
