source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.2.2.1'
# Use pg as the database for Active Record
gem 'pg', '~> 1.1', '>= 1.1.3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', require: 'rack/cors'

# env file
gem 'dotenv-rails', '~> 2.5'

# api json
gem 'active_model_serializers', '~> 0.10.7'

# paginate
gem 'kaminari', '~> 1.1', '>= 1.1.1'

# pry and ap
gem 'pry-rails', '~> 0.3.6'
gem 'awesome_print', '~> 1.8'

# parse json
gem 'oj', '~> 3.6', '>= 3.6.11'

# Redis
gem 'hiredis', '~> 0.6.1'
gem 'redis', '~> 4.0', '>= 4.0.2'
# gem 'redis-namespace', '~> 1.6'
gem 'redis-objects', '~> 1.4', '>= 1.4.3'

# Sidekiq
gem 'sidekiq', '~> 5.2', '>= 5.2.2'
gem 'sidekiq-unique-jobs', '~> 6.0', '>= 6.0.6'

# Deployment
gem 'mina', require: false
gem 'mina-puma', require: false
gem 'mina-multistage', require: false
gem 'mina-sidekiq', '~> 1.0', '>= 1.0.3', require: false

# appchain sdk
gem 'appchain.rb', '0.1.0'
# ethereum sdk
gem 'eth', '~> 0.4.10'
gem 'ethereum.rb', '~> 2.2'

gem 'daemons', '~> 1.2', '>= 1.2.6'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails', '~> 4.11', '>= 4.11.1'
  gem 'database_cleaner', '~> 1.7'
  gem 'simplecov', '~> 0.16.1', require: false

  gem 'rubocop', '~> 0.59.2', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
