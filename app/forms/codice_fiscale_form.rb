class CodiceFiscaleForm
  include ActiveModel::Model

  attr_accessor :first_name, :last_name, :gender, :date_of_birth, :place_of_birth, :website_codice_fiscale

  validates :first_name, :last_name, :gender, :date_of_birth, :place_of_birth, presence: true
  # DO NOT validate website_codice_fiscale for presence here
end
