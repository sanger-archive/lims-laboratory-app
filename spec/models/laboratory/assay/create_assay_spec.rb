# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'

#Model requirements
require 'lims-laboratory-app/laboratory/assay/create_assay'
require 'lims-core/persistence/store'

module Lims::LaboratoryApp::Laboratory
  describe Assay::CreateAssay do
    context "with a valid store" do
      include_context "create object"
      let (:store) { Lims::Core::Persistence::Store.new }

      # define the parameters for an assay
      let(:name)        { "assay name" }
      let(:allele_x)    { Allele::A }
      let(:allele_y)    { Allele::G }

      include_context("for application", "Test create an assay")

      context "create an assay" do
        subject { 
          Assay::CreateAssay.new( :store        => store,
                                  :user         => user,
                                  :application  => application) do |action, session|
            action.name = name
            action.allele_y = allele_y
            action.allele_x = allele_x
          end
        }

        it_behaves_like "an action"

        it "creates an assay when called" do
          Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
          result = subject.call
          result.should be_a(Hash)

          assay = result[:assay]
          assay.should be_a(Assay)
          assay.name.should == name
          assay.allele_x.should == allele_x
          assay.allele_y.should == allele_y
        end
      end
    end
  end
end
