module ApplicationHelper
  def nav_link(text, link)
    recognized = Rails.application.routes.recognize_path(link)
    if recognized[:controller] == params[:controller] && recognized[:action] == params[:action]
      link_to text, link, class: 'active'
    else
      link_to text, link
    end
  end
end
