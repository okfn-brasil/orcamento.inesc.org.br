source 'https://rubygems.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use Slim for html abstraction
gem 'slim-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Sass flavoured Twitter Boostrap for Rails
gem 'bootstrap-sass-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0.rc2'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'angularjs-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'rails_12factor', group: :production

# App monitoring
gem 'newrelic_rpm'

# JavaScript Crawler for Search Bots
gem 'google_ajax_crawler', git: 'git://github.com/vitorbaptista/google-ajax-crawler.git'
gem 'google_ajax_crawler_phantomjs', git: 'git://github.com/vitorbaptista/google_ajax_crawler_phantomjs.git'

# Enable gzipping assets
gem 'heroku-deflater', :group => :production

# Asset caching
group :production do
  gem 'rack-cache'
  gem 'dalli'
  gem 'kgio'
end
