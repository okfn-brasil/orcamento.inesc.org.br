if defined?(Rails.configuration) && Rails.configuration.respond_to?(:middleware)
  require 'google_ajax_crawler'
  Rails.configuration.middleware.use GoogleAjaxCrawler::Crawler do |config|
    config.page_loaded_test = lambda {|driver| driver.page.evaluate_script('document.getElementsByClassName("loading").length == 0') }
    config.driver = GoogleAjaxCrawler::Drivers::Poltergeist
  end
end
