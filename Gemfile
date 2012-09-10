source 'http://ruby.taobao.org'

gem 'rails', '3.2.6'
gem 'bootstrap-sass', '2.0.0'
# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '3.0.1'

# 这个是能够自动为 Model 生成 comment 的 jar
gem 'annotate', '2.5.0', group: :development

#gem 'mysql2'
gem 'pg'

gem 'will_paginate'
gem 'bootstrap-will_paginate'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'thin'
  gem 'faker'
end

group :test do
  gem 'capybara'
  gem 'spork-rails'
  gem 'factory_girl_rails'
end


group :production do
  gem 'unicorn'
end

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
