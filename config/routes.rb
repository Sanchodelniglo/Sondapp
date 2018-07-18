Rails.application.routes.draw do

  devise_for :users
  root to: 'probings#last'

  resources :probings, only:[:index, :show, :new, :create]


end
