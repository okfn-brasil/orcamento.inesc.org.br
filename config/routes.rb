Inesc::Application.routes.draw do

  get  'sobre-o-projeto' => 'home#about', as: :about
  get  'quem-somos' => 'home#who_we_are', as: :who_we_are
  get  'perguntas-frequentes' => 'home#faq', as: :faq
  get  'analises-do-orcamento-federal' => 'home#budget_analysis', as: :budget_analysis
  get  'contato' => 'home#contact', as: :contact

  get  '/:orgao/:ano' => 'home#profile'
  get  '/:orgao/:unidade_orcamentaria/:ano' => 'home#profile'
  get  '/:ano' => 'home#index'

  root 'home#index'

end
