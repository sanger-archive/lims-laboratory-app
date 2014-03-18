#receptacle_spec.rb
require 'models/laboratory/spec_helper'
require 'integrations/laboratory/resource_shared'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/laboratory/container/receptacle'

shared_examples_for "a receptacle" do 
  let(:mime_type) { "application/json" }
  it { subject.should respond_to(:receptacle_to_stream) }
  let(:aliquot_type) { 'sample' }
  let(:aliquot_quantity) { 10 }
  let(:unit_type) { "mole" }
  let(:sample_name) { "sample 1" } 
  include_context "with filled aliquots"
  it { 
    stream = Lims::Api::StructStream.new
    subject.receptacle_to_stream(stream,receptacle, mime_type) 
    stream.struct.should eq(aliquot_array)
  }
end

module Lims::LaboratoryApp::Laboratory
  describe Container::Receptacle do
    context "an object with receptacle" do
      subject do
        Object.new.tap do |object| 
          class << object
            include Lims::LaboratoryApp::Laboratory::Container::Receptacle
            include Lims::Api::Resource
          end
        end
      end

      let(:sample_uuid) { "12345" }
      let(:sample) { aliquot_array.first["sample"] }
      let(:aliquot) { 
        double(:aliquot).tap do |aliquot|
          aliquot.stub(:attributes) { {"sample" => sample, "type" => aliquot_type, "quantity" => aliquot_quantity } }
          aliquot.stub(:unit) { unit_type }
        end
      }
      let(:receptacle) { [aliquot] }

      it_behaves_like "a receptacle"
    end

  end
end
