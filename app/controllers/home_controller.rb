class HomeController < ApplicationController

  BASE_URL = 'http://orcamento.inesc.org.br'

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

  def sitemap
    require 'net/http'
    result = Net::HTTP.get('openspending.org', '/api/2/aggregate?dataset=orcamento_federal&drilldown=orgao|uo|time.year')
    parsed = ActiveSupport::JSON.decode(result)
    entities = parsed['drilldown'].map do |d|
      year = d['time']['year']
      uo = d['uo']
      orgao = d['orgao']

      [generate_url(orgao, year),
       generate_url(orgao, year, uo)]
    end.flatten.uniq
    entities << BASE_URL

    render text: entities.join("\n")
  end

  private
  def generate_url(orgao, year, uo=nil)
    if uo
      "#{BASE_URL}/#{slug(orgao)}/#{slug(uo)}/#{year}"
    else
      "#{BASE_URL}/#{slug(orgao)}/#{year}"
    end
  end

  def slug(entity)
    "#{entity['name']}-#{entity['label'].parameterize}"
  end
end
