require 'lims-laboratory-app/organization/location'
require 'models/actions/spec_helper'
require 'models/actions/action_examples'

shared_examples_for "creating a resource with a location" do |resource_class|
  it_behaves_like "an action"  

  it "creates a resource with a location" do
    Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
    result = subject.call
    result.should be_a(Hash)
    result.delete(:uuid).should == uuid
    model_name = result.keys.first
    result[model_name].should be_a(resource_class)
    result[model_name].should respond_to(:location)
    result[model_name].location.name.should == name
    result[model_name].location.address.should == address
    result[model_name].location.internal.should == internal
  end
end
