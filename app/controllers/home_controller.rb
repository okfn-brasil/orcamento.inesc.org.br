class HomeController < ApplicationController

  BASE_URL = 'http://orcamento.inesc.org.br'

  def index
    @slideshow_content = [
      {
        title: 'Orçamento ao Seu Alcance',
        content: 'O portal Orçamento ao seu Alcance desenvolvido pelo INESC (Instituto de Estudos Socioeconômicos), em parceria com a Open Knowledge Foundation Brasil, tem como objetivo visualizar o orçamento federal de forma mais simples. Ele sintetiza informações atualizadas e mensais sobre o desembolso financeiro dos ministérios e demais órgãos federais, que permitirá um acompanhamento do desempenho desses órgãos ao longo do ano, assim como comparações entre o volume de recursos disponíveis para cada área do governo federal.',
        image: 'showcase-project.png',
        url: nil
      },{
        title: 'Origem dos Dados',
        content: 'Os dados utilizados pelo portal são extraídos do Siga Brasil, que é um sistema de informações orçamentárias que reúne diversas bases de dados (SIAFI, SIOP, SELOR etc.) e as coloca à disposição da sociedade para acesso direto e facilitado.',
        image: 'showcase-siga-brasil.png',
        url: 'http://www12.senado.gov.br/orcamento/sigabrasil'
      },{
        title: 'De onde vem o Dinheiro',
        content: 'O orçamento público é formado pelos tributos pagos por milhões de brasileiros/as. Esses recursos são públicos e pertencem à coletividade. Os governos têm a obrigação de alocar o máximo de recursos disponíveis para políticas públicas que promovam os direitos humanos, reduzam as desigualdades sociais e garantam a sustentabilidade ambiental, assim como prevê a Constituição Federal, os tratados internacionais e a legislação brasileira.',
        image: 'showcase-payments.png',
        url: nil
      },{
        title: 'Justiça Tributária',
        content: 'Grande parte das receitas governamentais, ou seja, do dinheiro que o governo arrecada, sai do nosso bolso, direta ou indiretamente. Devido ao nosso sistema tributário ser regressivo e injusto, os pobres pagam, proporcionalmente, mais impostos do que os ricos. A maior parte da população não sabe que paga impostos quando compra alimentos, roupas ou um eletrodoméstico, pois os impostos estão embutidos no preço dos produtos. O sistema tributário brasileiro produz desigualdade e precisa ser modificado.',
        image: 'showcase-distribuicao-uo.png',
        url: nil
      },{
        title: 'Participação Popular',
        content: 'Parte significativa do orçamento público é destinada para o sistema financeiro (por meio de juros e amortizações da dívida pública), para atender interesses de grupos econômicos e políticos ou se perdem na corrupção. O orçamento público pertence ao povo. Temos que ficar de olho e verificar quais são esses recursos, de onde vem e para onde vai. Somente com pressão e participação popular poderemos garantir que os recursos públicos sejam destinados para a construção de uma sociedade livre, justa e sustentável.',
        image: 'showcase-monitor.png',
        url: nil
      }
    ]
  end

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
