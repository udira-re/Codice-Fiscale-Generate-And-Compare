# app/lib/comuni_loader.rb
require "json"

module ComuniLoader
  FILE_PATH = Rails.root.join("app/data/comuni_e_stati.json")
  @data = JSON.parse(File.read(FILE_PATH))

  class << self
    # Find a place by name (case-insensitive)
    def find_by_name(name)
      return nil unless name

      @data.find do |c|
        c["name"].upcase.strip == name.strip.upcase
      end
    end

    # Example helper: get codice catastale for a place
    def codice_catastale_for(name)
      place = find_by_name(name)
      place ? place["code"] : nil
    end

    # Example helper: get province (returns nil if foreign)
    def province_for(name)
      place = find_by_name(name)
      place ? place["province"] : nil
    end
  end
end
