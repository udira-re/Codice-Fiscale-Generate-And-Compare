class CodiceFiscalesController < ApplicationController
  def index
    # restore form data after redirect
    @form = CodiceFiscaleForm.new(flash[:form_data] || {})
  end

 def create
  @form = CodiceFiscaleForm.new(form_params)

  if @form.valid?
    generator = CodiceFiscale::Generator.new(form_params)

    raw_generated_cf = generator.generate
    formatted_generated_cf = generator.formatted

    provided = normalize_cf(@form.website_codice_fiscale)
    generated = normalize_cf(raw_generated_cf)

    matched = nil

    # 🔹 Compare ONLY if user pasted website CF
    if provided.present?
      matched = (provided == generated)
      flash[:result] = matched ? "VALID ✅" : "INVALID ❌"
    else
      flash[:result] = "Codice Fiscale generated successfully ✅"
    end

    CodiceFiscaleRecord.create!(
      first_name: @form.first_name,
      last_name: @form.last_name,
      gender: @form.gender,
      date_of_birth: @form.date_of_birth,
      place_of_birth: @form.place_of_birth,
      provided_cf: provided.presence,
      generated_cf: generated,
      matched: matched
    )

    flash[:generated_cf] = formatted_generated_cf
  else
    flash[:result] = "Please fill all required fields ❌"
  end

  flash[:form_data] = form_params
  redirect_to codice_fiscales_path
end


  private

  def form_params
    params.require(:codice_fiscale_form).permit(
      :first_name,
      :last_name,
      :gender,
      :date_of_birth,
      :place_of_birth,
      :website_codice_fiscale
    )
  end

  def normalize_cf(value)
    value.to_s.upcase.gsub(/[^A-Z0-9]/, "")
  end
end
