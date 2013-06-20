Inesc::Application.routes.draw do

  root 'home#index'
  get '/orgao' => 'home#orgao'
  get '/uo' => 'home#uo'

end
