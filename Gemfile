source 'https://rubygems.org'
ruby '2.0.0'

gem 'acts-as-taggable-on', '~> 3.4.2'
gem 'airbrake', '~> 4.1.0'
gem 'bourbon', '~> 3.2.3'
gem 'choices', '~> 0.4.0'
gem 'daemons', '~> 1.1.9'
gem 'delayed_job_active_record', '~> 4.0.2'
gem 'delayed_job_web', '~> 1.2.9'
gem 'devise'
gem 'devise-encryptable'
gem 'draper', '~> 1.4.0'
gem 'sass-rails', '~> 4.0.4'
gem 'compass-rails', '~> 2.0.0'
gem 'bootstrap-sass', '~> 3.3.0'
gem 'pivotal-sass'
gem 'haml-rails', '~> 0.5.3'
gem 'jquery-rails', '~> 3.1.2'
gem 'nokogiri', '~> 1.6.3.1'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'pivotal-tracker'
gem 'rails', '4.0.11'
gem 'rake'
gem 'whenever', require: false
gem 'rails-backbone', git: 'https://github.com/codebrew/backbone-rails', tag: 'v1.1.2'
gem 'coffee-rails', '~> 4.0.0'
gem 'eco', '~> 1.0.0'
gem 'pg', '>= 0.17.1'
gem 'eventmachine'
gem 'em-http-request'
gem 'newrelic_rpm'
gem 'unicorn', '~> 4.8.3'
gem 'uglifier', '>= 1.3.0'
gem 'clockwork'
gem 'jbuilder', '~> 2.2.4'
gem 'ruby-openid', '~> 2.5.0'

group :production do
  gem 'rails_12factor'
  gem 'therubyracer'
end

group :test do
  gem 'headless'
  gem 'vcr', '~> 2.9.3'
  gem 'webmock', '~> 1.20.0'
end

# NOTE: anything that will not work in travis should be here
group :development do
  gem 'awesome_print'
  gem 'heroku_san'
  gem 'guard-livereload'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'ruby-prof'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman', '~> 0.75.0'
end

group :test, :development do
  gem 'launchy'
  gem 'jshint_on_rails'
  gem 'rspec-rails', '~> 3.1.0'
  gem 'shoulda-matchers'
  gem 'capybara', '~> 2.4.4'
  gem 'jasmine'
  gem 'jasmine-rails'
  gem 'selenium-webdriver', '>= 2.25.0' # NOTE: selenium-webdriver >= 2.25.0 is needed for the latest Firefox
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'guard-coffeescript'
  gem 'database_cleaner'
  gem 'capybara-webkit'
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'pry'
  gem 'timecop'
  gem 'did_you_mean'
end