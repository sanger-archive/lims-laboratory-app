# Spec requirements
require 'models/laboratory/spec_helper'
require 'models/laboratory/location_shared'
require 'models/laboratory/located_examples'
require 'models/laboratory/receptacle_examples'
require 'models/labels/labellable_examples'

# Model requirements
require 'lims-laboratory-app/laboratory/tube'

module Lims::LaboratoryApp::Laboratory
  describe Tube, :tube => true, :laboratory => true  do

    def self.it_can_assign(attribute)
      it "can assign #{attribute}" do
        value = double(:attribute)
        subject.send("#{attribute}=", value)
        subject.send(attribute).should == value
      end
    end

    it_behaves_like "located" 
    it_behaves_like "receptacle"
    it_behaves_like "labellable"

    it_can_assign :type
    it_can_assign :max_volume

    it_behaves_like "can have a location"

    it "sets a type" do
      type = double(:type)
      subject.type = type
      subject.type.should == type
    end

    it "sets a max volume" do
      max_volume = double(:max_volume)
      subject.max_volume = max_volume
      subject.max_volume.should == max_volume
    end

  end
end
