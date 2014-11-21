source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'
gem 'rails-api'
gem 'pg'
gem 'thin'
gem 'warden'
gem 'state_machine'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# Use Capistrano for deployment
group :development do
  gem "parallel_tests"
  gem 'railroady'

  gem 'capistrano'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv', github: "capistrano/rbenv"

  #gem 'capistrano-console'

  #gem "capistrano-ext"
  #gem "capistrano-deploytags"
  gem "brakeman", :require => false
  gem "hirb"
end

group :development, :test do
  gem "factory_girl_rails"
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-rails'
  #gem 'pry-debugger'
  gem "spork", "~> 1.0rc"
  gem "better_errors"
  gem "binding_of_caller"
  gem 'rspec-rails' # Needed for rake stats to calculate test coverage
  gem "awesome_print"
end

group :it, :staging, :development, :test, :uat, :production do
  gem 'ruby-progressbar'
  gem "colorize"
end

group :test do
  gem "shoulda"
  gem 'cucumber-rails', :require => false
  gem 'cucumber-websteps'
  gem 'pickle'
  gem 'capybara'
  gem 'database_cleaner'
end
