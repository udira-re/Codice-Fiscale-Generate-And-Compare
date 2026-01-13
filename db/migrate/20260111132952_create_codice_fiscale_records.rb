class CreateCodiceFiscaleRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :codice_fiscale_records do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.date :date_of_birth
      t.string :provided_cf
      t.string :generated_cf
      t.boolean :matched

      t.timestamps
    end
  end
end
