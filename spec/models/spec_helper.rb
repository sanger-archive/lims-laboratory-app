require 'spec_helper'

shared_examples "requires" do |attribute|
  context "without #{attribute}" do
    let(:excluded_parameters) { [attribute] }
    it "'s not valid" do
      subject.valid?.should == false
    end
  end
end

if RUBY_PLATFORM == "java"
  require 'jdbc/sqlite3'
  shared_examples "sqlite store" do
    let(:db) { ::Sequel.connect('jdbc:sqlite::memory:') }
    let(:store) { Lims::Core::Persistence::Sequel::Store.new(db) }
    include_context "clean store"
  end
else
  shared_examples "sqlite store" do
    let(:db) { ::Sequel.sqlite('') }
    let(:store) { Lims::Core::Persistence::Sequel::Store.new(db) }
    include_context "clean store"
  end
end
