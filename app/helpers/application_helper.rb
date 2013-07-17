module ApplicationHelper
  def nav_link(text, link)
    recognized = Rails.application.routes.recognize_path(link)
    if recognized[:controller] == params[:controller] && recognized[:action] == params[:action]
      link_to text, link, class: 'active'
    else
      link_to text, link
    end
  end

  def pages
    [
      { label: 'Sobre o Projeto', path: about_path },
      { label: 'Quem Somos', path: who_we_are_path },
      { label: 'Perguntas Frequentes', path: faq_path },
      { label: 'Análises do Orçamento Federal', path: budget_analysis_path },
      { label: 'Contato', path: contact_path }
    ]
  end
end
