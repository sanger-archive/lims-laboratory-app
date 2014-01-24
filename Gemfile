source 'http://rubygems.org'

# Specify your gem's dependencies in lims-laboratory-app.gemspec
gemspec

gem 'sinatra', :git => 'http://github.com/sinatra/sinatra.git', :branch => '459369eb66224836f72e21bbece58c007f3422fa'
gem 'lims-core', '~>3.1.0.pre', :git => 'http://github.com/sanger/lims-core.git' , :branch => 'uat'
#gem 'lims-core', :path => '../lims-core'
gem 'lims-api', '~>3.1.1.pre', :git => 'http://github.com/sanger/lims-api.git' , :branch => 'uat'
#gem 'lims-api', :path => '../lims-api'
gem 'lims-exception-notifier-app', '~>0.1', :git => 'http://github.com/sanger/lims-exception-notifier-app.git', :branch => 'master'
#gem 'lims-exception-notifier-app', :path => '../lims-exception-notifier-app'

group :debugging do
  gem 'debugger', :platforms => :mri
  gem 'debugger-completion', :platforms => :mri
  gem 'ruby-debug', :platforms => :jruby
end

group :development do
  gem 'sqlite3', :platforms => :mri
  gem 'mysql2', :platforms => :mri
  gem 'ruby-prof', :platforms => :mri
  gem 'jdbc-sqlite3', :platforms => :jruby
  gem 'jdbc-mysql', :platforms => :jruby
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
