source 'https://rubygems.org'

# Specify your gem's dependencies in lims-laboratory-app.gemspec
gemspec

gem 'sinatra', :git => 'http://github.com/sinatra/sinatra.git', :branch => '459369eb66224836f72e21bbece58c007f3422fa'
gem 'lims-core', '~>2.0', :git => 'http://github.com/sanger/lims-core.git' , :branch => 'version-2'
#gem 'lims-core', :path => '../lims-core'
gem 'lims-api', '~>2.0', :git => 'http://github.com/sanger/lims-api.git' , :branch => 'version-2'
#gem 'lims-api', :path => '../api'


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
