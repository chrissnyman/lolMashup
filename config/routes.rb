Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/rails_admin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '' => 'home#welcome'
  get 'summoner/' => 'summoner#overview'
  post 'summoner/' => 'summoner#search'
  get 'summoner/:region/:summoner_name' => 'summoner#overview'

  get 'group/list' => 'group#list'
  get 'group/new' => 'group#new'
  post 'group/create' => 'group#create'
  get 'group/:uuid/edit' => 'group#edit'
  post 'group/update' => 'group#update'
  post 'group/add_summoner' => 'group#add_summoner'
  get 'group/:uuid/remove_summoner/:summoner_match_group_id' => 'group#add_summoner'
  get 'group/:uuid' => 'group#show'
  get 'group/:uuid/roll' => 'group#roll'
  get 'group/:uuid/last_updated' => 'group#get_last_updated'
end
