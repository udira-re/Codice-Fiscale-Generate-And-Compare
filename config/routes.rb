Rails.application.routes.draw do
  get "codice_fiscales/index"
  get "codice_fiscales/create"
  root "codice_fiscales#index"
  resources :codice_fiscales, only: [ :index, :create ]
end
