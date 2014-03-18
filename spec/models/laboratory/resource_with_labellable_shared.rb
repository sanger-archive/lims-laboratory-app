require 'lims-laboratory-app/labels/labellable/all'
require 'models/actions/spec_helper'
require 'models/actions/action_examples'

shared_examples_for "creating a resource with a labellable" do |resource_class|
  it_behaves_like "an action"  
  
  let(:labels) {{
    "front barcode" => {
      "value" => "1234-ABC",
      "type" => "sanger-barcode"
    },
    "back barcode" => {
      "value" => "5678-DEF",
      "type" => "ean13-barcode"
    }
  }}

  it "creates a resource with a labellable" do
    Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
    result = subject.call
    result.should be_a(Hash)
    result.delete(:uuid).should == uuid
    model_name = result.keys.first
    result[model_name].should be_a(resource_class)
    result[model_name].should respond_to(:labellable)
    result[model_name].labellable.size.should == 2
    result[model_name].labellable["front barcode"].value.should == "1234-ABC"
    result[model_name].labellable["front barcode"].type.should == "sanger-barcode"
    result[model_name].labellable["back barcode"].value.should == "5678-DEF"
    result[model_name].labellable["back barcode"].type.should == "ean13-barcode"
  end
end
