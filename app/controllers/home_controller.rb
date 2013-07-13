class HomeController < ApplicationController

  def index; end

  def profile
    @slug   = params[:orgao]
    @orgao  = params[:orgao].gsub("-", " ").titleize
    @ano    = params[:ano].to_i
  end

  def about; end

  def who_we_are; end

  def faq; end

  def budget_analysis; end

  def contact; end

end
