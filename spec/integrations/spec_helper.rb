#shared contexts for integrations
require 'spec_helper'
require 'lims-laboratory-app'

require 'logger'
require 'yaml'
Loggers = []
#Loggers << Logger.new($stdout)

def connect_db(env)
  config = YAML.load_file(File.join('config','database.yml'))
  Sequel.connect(config[env.to_s], :loggers => Loggers)
end

def config_bus(env)
  YAML.load_file(File.join('config','amqp.yml'))[env.to_s] 
end

shared_context 'use core context service' do
  let(:db) { connect_db(:test) }
  let(:store) { Lims::Core::Persistence::Sequel::Store.new(db) }
  let(:message_bus) { double(:message_bus).tap { |m| 
    m.stub(:publish) 
    m.stub(:connect)
  } } 
  let(:context_service) { Lims::Api::ContextService.new(store, message_bus) }

  before(:each) do
    app.set(:context_service, context_service)
  end

  include_context "clean store"
end

shared_context 'JSON' do
  before(:each) {
    header('Accept', 'application/json')
    header('Content-Type', 'application/json')
  }
end

shared_context "use generated uuid" do 
  let! (:uuid) {
    '11111111-2222-3333-4444-555555555555'.tap do |uuid|
    Lims::Core::Persistence::UuidResource.stub(:generate_uuid).and_return(uuid)
    end
  }
end

shared_context "a valid core action" do |&extra|
  it "creates something" do
    response = post(url, parameters.to_json)
    response.should match_json_response(200, expected_json)
    extra.call(response) if extra
  end
end

shared_context "an invalid core action" do |expected_status, &extra|
  it "doesn't create anything" do
    response = post(url, parameters.to_json)
    if(expected_json)
      response.should match_json_response(expected_status,expected_json)
    else
      response.status.should  == expected_status
    end
    extra.call(response) if extra
  end
end
