class HomeController < ApplicationController

  def index
  end

  def profile
    @orgao = params[:orgao].gsub("-", " ").titleize
    @ano = params[:ano].to_i
  end

end
