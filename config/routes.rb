Inesc::Application.routes.draw do

  root 'home#index'
  get '/:orgao/:ano' => 'home#profile'

end
