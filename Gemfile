source 'https://rubygems.org'

gem 'rails', '6.0.3.4'
gem 'pg', '>= 0.18', '< 2.0'
gem 'haml-rails', '~> 2.0'
gem 'jquery-rails', '~> 4.3'
gem 'sassc-rails', '~> 2.1'
# start: until problems solved
# gem 'bootstrap', '~> 4.5'
gem 'autoprefixer-rails', '9.8.5'
gem 'bootstrap', '4.5.0'
# end: until problems solved
gem 'uglifier', '~> 4.2'
gem 'bcrypt', '~> 3.1.7'
gem 'jbuilder', '~> 2.7'
gem 'meta-tags', '~> 2.12'
gem 'cancancan', '~> 3.0'
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'rspec-rails', '~> 4.0.0'
  gem 'capybara', '~> 3.28'
  gem 'factory_bot_rails', '~> 6.0'
  gem 'faker', '~> 2.10'
  gem 'byebug', platform: :mri
end

group :test do
  gem 'database_cleaner-active_record', '~> 1.8'
end

group :development do
  gem 'puma', '~> 5.0'
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-passenger', '~> 0.2', require: false
  gem 'listen', '~> 3.2'
end
