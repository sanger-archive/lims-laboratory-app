# Spec requirements
require 'models/persistence/sequel/spec_helper'

require 'models/persistence/sequel/store_shared'
require 'models/persistence/resource_shared'


# Model requirements
require 'lims-laboratory-app/laboratory/aliquot/all'


module Lims::LaboratoryApp
  describe "Sequel#Aliquot" do
    include_context "sequel store"

    context do
      let!(:aliquot_id) { save(Laboratory::Aliquot.new(:quantity => 5.001, :type => :solvent)) }
      it "saved nanolitre" do
        db[:aliquots].filter(:id => aliquot_id).first[:quantity].should == 5001
      end

      it "load microliter" do
        store.with_session do |session|
          session.aliquot[aliquot_id].quantity.should == 5.001
        end
      end

     xit "raises an error if information lost" do
        expect { save(Laboratory::Aliquot.new(:quantity => 5.0001, :type => :solvent))  }.to raise_error(RuntimeError)
      end
    end
  end
end
