Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '' => 'home#welcome'
  get 'summoner/' => 'summoner#overview'
  post 'summoner/' => 'summoner#search'
  get 'summoner/:region/:summoner_name' => 'summoner#overview'

  get 'group/new' => 'group#new'
  post 'group/create' => 'group#create'
  post 'group/add_summoner' => 'group#add_summoner'

  get 'group/:uuid' => 'group#show'
  get 'group/:uuid/roll' => 'group#roll'
  get 'group/:uuid/last_updated' => 'group#get_last_updated'
  get 'group/:uuid/change_game_mode/:game_mode_id' => 'group#change_game_mode'
end
