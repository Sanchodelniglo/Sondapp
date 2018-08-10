Rails.application.routes.draw do

  devise_for :users
  root to: 'probings#last'

  get 'probings/wtf.pdf', to: 'probings#show', as: :pdf

  resources :probings, only:[:index, :new, :create]


end
