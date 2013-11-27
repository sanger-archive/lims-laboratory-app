require 'spec_helper'

shared_examples "requires" do |attribute|
  let(:excluded_parameters) { [attribute] }
  context "without #{attribute}" do
    it "is not valid" do
      subject.valid?.should == false
    end
  end

  context "after validation" do
    before { subject.validate }
    it "#{attribute} is required" do
      subject.errors[attribute].should_not be_empty
    end
  end
end

shared_examples "has an attribute of" do |attribute, type|
  it "#{attribute}" do
    subject.should respond_to(attribute)
  end

  it "and #{attribute} is a #{type}" do
    subject.send(attribute).andtap { |v| v.should be_a(type) }
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
