# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'

#Model requirements
require 'lims-laboratory-app/laboratory/snp_assay/all'
require 'lims-laboratory-app/laboratory/snp_assay/create_snp_assay'
require 'lims-core/persistence/store'

module Lims::LaboratoryApp::Laboratory
  describe SnpAssay::CreateSnpAssay do
    context "with a valid store" do
      include_context "create object"
      let (:store) { Lims::Core::Persistence::Store.new }

      # define the parameters for an snp assay
      let(:name)        { "assay name" }
      let(:allele_x)    { Allele::A }
      let(:allele_y)    { Allele::G }

      include_context("for application", "Test create an snp assay")

      context "create an snp assay" do
        subject {
          SnpAssay::CreateSnpAssay.new( :store        => store,
                                        :user         => user,
                                        :application  => application) do |action, session|
            action.name = name
            action.allele_y = allele_y
            action.allele_x = allele_x
          end
        }

        it_behaves_like "an action"

        it "creates an snp assay when called" do
          Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
          result = subject.call
          result.should be_a(Hash)

          snp_assay = result[:snp_assay]
          snp_assay.should be_a(SnpAssay)
          snp_assay.name.should == name
          snp_assay.allele_x.should == allele_x
          snp_assay.allele_y.should == allele_y
        end
      end
    end
  end
end
