source 'https://rubygems.org'

# Specify your gem's dependencies in lims-s2-app.gemspec
gemspec

gem 'lims-core', '~>1.5.0.1', :git => 'http://github.com/sanger/lims-core.git' , :branch => 'development'
gem 'lims-api', '~>1.2', :git => 'http://github.com/sanger/lims-api.git' , :branch => 'development'

group :debugging do
  gem 'debugger'
  gem 'debugger-completion'
end

group :yard do
  gem 'yard', '= 0.7.3'
  gem 'yard-rspec', '0.1'
  gem 'yard-state_machine'
  gem 'redcarpet'
  gem 'ruby-graphviz'
end
