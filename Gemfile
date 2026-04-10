source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'pg' # 本番用DB
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.0.10'
gem 'sprockets-rails'
gem 'sqlite3', '~> 1.4'

# Frontend / JS / CSS
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'turbo-rails'

# Auth / SNS Login
gem 'devise'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

# Utils
gem 'bootsnap', require: false
gem 'kaminari'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Mail (Rails 7 / Ruby 3.1+)
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false

# --- Development & Test ---
group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'letter_opener_web'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
