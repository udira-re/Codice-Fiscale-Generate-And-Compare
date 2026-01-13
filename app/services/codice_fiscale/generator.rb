# app/services/codice_fiscale/generator.rb
module CodiceFiscale
  class Generator
    attr_reader :first_name, :last_name, :gender, :date_of_birth, :place_of_birth



    MONTH_CODES = {
      1 => "A", 2 => "B", 3 => "C", 4 => "D", 5 => "E",
      6 => "H", 7 => "L", 8 => "M", 9 => "P", 10 => "R",
      11 => "S", 12 => "T"
    }

    def initialize(params)
      @first_name = params[:first_name].upcase.strip
      @last_name = params[:last_name].upcase.strip
      @gender = params[:gender].upcase.strip
      @date_of_birth = params[:date_of_birth]
      @place_of_birth = params[:place_of_birth].upcase.strip
    end

    def generate
      cf = surname_code + name_code + date_code + place_code
      cf + control_character(cf)
    end
 def formatted
      raw = generate
      "#{raw[0, 3]} #{raw[3, 3]} #{raw[6, 5]} #{raw[11, 5]}"
    end
    private

    def surname_code
      code_letters(@last_name)
    end

   def name_code
  # get consonants
  consonants = @first_name.gsub(/[^A-Z]/, "").chars.select { |c| c =~ /[BCDFGHJKLMNPQRSTVWXYZ]/ }
  vowels = @first_name.gsub(/[^A-Z]/, "").chars.select { |c| c =~ /[AEIOU]/ }

  # Special rule: if consonants >=4, take 1st, 3rd, 4th
  if consonants.size >= 4
    letters = consonants[0] + consonants[2] + consonants[3]
  else
    letters = consonants.join
  end

  code = (letters + vowels.join)[0, 3].ljust(3, "X")
  code
end


    def date_code
      d = Date.parse(@date_of_birth.to_s)
      year = d.year.to_s[-2..-1]
      month = MONTH_CODES[d.month]
      day = @gender == "F" ? (d.day + 40).to_s.rjust(2, "0") : d.day.to_s.rjust(2, "0")
      "#{year}#{month}#{day}"
    end

 def place_code
      place = ComuniLoader.find_by_name(@place_of_birth)
      if place
        place["code"] # Italian or foreign code
      else
        "Z999"       # fallback if not found
      end
    end


    def control_character(cf_first_15)
      odd_table = { "0"=>1, "1"=>0, "2"=>5, "3"=>7, "4"=>9, "5"=>13, "6"=>15, "7"=>17, "8"=>19, "9"=>21,
                    "A"=>1, "B"=>0, "C"=>5, "D"=>7, "E"=>9, "F"=>13, "G"=>15, "H"=>17, "I"=>19, "J"=>21,
                    "K"=>2, "L"=>4, "M"=>18, "N"=>20, "O"=>11, "P"=>3, "Q"=>6, "R"=>8, "S"=>12, "T"=>14,
                    "U"=>16, "V"=>10, "W"=>22, "X"=>25, "Y"=>24, "Z"=>23 }

      even_table = { "0"=>0, "1"=>1, "2"=>2, "3"=>3, "4"=>4, "5"=>5, "6"=>6, "7"=>7, "8"=>8, "9"=>9,
                     "A"=>0, "B"=>1, "C"=>2, "D"=>3, "E"=>4, "F"=>5, "G"=>6, "H"=>7, "I"=>8, "J"=>9,
                     "K"=>10, "L"=>11, "M"=>12, "N"=>13, "O"=>14, "P"=>15, "Q"=>16, "R"=>17, "S"=>18, "T"=>19,
                     "U"=>20, "V"=>21, "W"=>22, "X"=>23, "Y"=>24, "Z"=>25 }

      total = cf_first_15.upcase.chars.each_with_index.reduce(0) do |sum, (c, idx)|
        sum + (idx.even? ? odd_table[c] : even_table[c])
      end
      ("A".ord + total % 26).chr
    end

    def code_letters(name)
      consonants = name.gsub(/[^BCDFGHJKLMNPQRSTVWXYZ]/, "")
      vowels = name.gsub(/[^AEIOU]/, "")
      (consonants + vowels)[0, 3].ljust(3, "X")
    end
  end
end
