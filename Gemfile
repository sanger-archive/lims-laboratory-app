source 'http://rubygems.org'

# Specify your gem's dependencies in lims-laboratory-app.gemspec
gemspec

gem 'sinatra', :git => 'http://github.com/sinatra/sinatra.git', :branch => '459369eb66224836f72e21bbece58c007f3422fa'
gem 'lims-core', '~>2.1', :git => 'http://github.com/sanger/lims-core.git' , :branch => 'development'
#gem 'lims-core', :path => '../lims-core'
gem 'lims-api', '~>2.2', :git => 'http://github.com/sanger/lims-api.git' , :branch => 'development'
#gem 'lims-api', :path => '../lims-api'


group :debugging do
  gem 'debugger', :platforms => :mri
  gem 'debugger-completion', :platforms => :mri
end

group :development do
  gem 'sqlite3', :platforms => :mri
end

group :yard do
  gem 'yard', '= 0.7.3', :platforms => :mri
  gem 'yard-rspec', '0.1', :platforms => :mri
  gem 'yard-state_machine', :platforms => :mri
  gem 'redcarpet', :platforms => :mri
  gem 'ruby-graphviz', :platforms => :mri
end

group :deployment do
  gem "psd_logger", :git => "http://github.com/sanger/psd_logger.git"
  gem 'trinidad', :platforms => :jruby
  gem "trinidad_daemon_extension", :platforms => :jruby
  gem 'activesupport', '~> 3.0.0', :platforms => :jruby
  gem 'jdbc-mysql', :platforms => :jruby
end
