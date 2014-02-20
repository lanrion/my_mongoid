source 'https://rubygems.org'

# Add in Gemfile
group :test do
  gem "pry-rails"

  gem "rspec", "~> 3.0.0.beta1"

  if ENV["CI"]
    gem "coveralls", require: false
  end
end

# Specify your gem's dependencies in my_mongoid.gemspec
gemspec
