source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
gem 'sqlite3'
gem 'sidekiq'
gem 'paperclip'
gem 'puma', '~> 4.3'

gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.5'
gem 'sprockets', git: 'https://github.com/rails/sprockets'
gem 'babel-transpiler'
gem 'sprockets-commoner'

gem 'faraday'
gem 'faraday_middleware'

gem 'graphql'
gem 'graphql-batch', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'awesome_print', '~> 1.1.0'
  gem 'pry', require: false
  gem 'pry-rails'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'graphiql-rails'
end
