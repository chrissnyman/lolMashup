Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '' => 'home#welcome'
  post 'summoner/' => 'summoner#search'
  get 'summoner/:region/:summoner_name' => 'summoner#overview'
end
