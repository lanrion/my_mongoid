source 'http://rubygems.org'

# Add in Gemfile
group :test do
  gem "pry-rails"
  gem "pry-debugger", "~> 0.2.2"

  gem "rspec", "~> 3.0.0.beta1"

  if ENV["CI"]
    gem "coveralls", require: false
  end
end

# Specify your gem's dependencies in my_mongoid.gemspec
gemspec
