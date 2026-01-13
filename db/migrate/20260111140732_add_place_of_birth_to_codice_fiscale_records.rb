class AddPlaceOfBirthToCodiceFiscaleRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :codice_fiscale_records, :place_of_birth, :string
  end
end
