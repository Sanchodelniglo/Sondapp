Rails.application.routes.draw do

  devise_for :users
  root to: 'probings#last'

  get 'probings/pdf_download.pdf', to: 'probings#pdf_download', as: :pdf

  resources :probings, only:[:index, :new, :create]


end
