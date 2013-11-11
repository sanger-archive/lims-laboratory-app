#vi: ts=2:sts=2:sw=2:et
require 'lims-laboratory-app'
require 'lims-api/server'
require 'lims-api/sequel'
require 'logger-middleware'

class Module
  def delegate(*names)
    options = names.pop
    names.each do |name|
      line = __LINE__ + 1
      class_eval(%Q{
        def #{name}(*args, &block)
          #{options[:to]}.send(#{name.to_sym.inspect}, *args, &block)
        end
      }, __FILE__, line)
    end
  end
end


Lims::Api::Server.configure(:example) do |config|
  config.set :context_service, ExampleContextService.new
end

Lims::Api::Server.configure(:development) do |config|
  store = Lims::Api::Sequel::create_store(:development)
  message_bus = Lims::Api::MessageBus::create_message_bus(:development)
  application_id = Gem::Specification::load("lims-laboratory-app.gemspec").name 
  config.set :context_service, Lims::LimsLaboratoryApp::ContextService.new(store, message_bus, application_id)
  config.set :base_url, "http://localhost:9292"
end

logger = Logger.new($stdout)

use LoggerMiddleware, logger

run Lims::Api::Server
