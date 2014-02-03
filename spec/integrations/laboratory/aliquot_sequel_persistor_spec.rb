# Spec requirements
require 'models/persistence/sequel/spec_helper'

require 'models/persistence/sequel/store_shared'
require 'models/persistence/resource_shared'
require 'models/laboratory/aliquot_shared'

# Model requirements
require 'lims-laboratory-app/laboratory/aliquot/all'
require 'lims-laboratory-app/laboratory/snp_assay/all'


module Lims::LaboratoryApp
  describe "Sequel#Aliquot" do
    include_context "sequel store"
    include_context "aliquot factory"

    # define the parameters for an aliquot
    let(:sample)        { new_sample }
    let(:snp_assay)     { new_snp_assay }
    let(:quantity)      { 5.001 }
    let(:type_solvent)  { :solvent }
    let(:parameters)    {
      { :quantity => quantity,
        :type     => type_solvent
      }
    }

    context "valid aliquot" do
      let!(:aliquot_id) { save(subject) }

      context "with sample" do
        subject { Laboratory::Aliquot.new(parameters.merge!(:sample => sample)) }
        it "saved nanolitre" do
          db[:aliquots].filter(:id => aliquot_id).first[:quantity].should == 5001
        end

        it "load microliter" do
          store.with_session do |session|
            session.aliquot[aliquot_id].quantity.should == quantity
          end
        end

        it "can have a sample" do
          store.with_session do |session|
            session.aliquot[aliquot_id].sample.should == sample
          end
        end

       xit "raises an error if information lost" do
          expect { save(Laboratory::Aliquot.new(:quantity => 5.0001, :type => :solvent))  }.to raise_error(RuntimeError)
        end
      end

      context "with snp_assay" do
        subject { Laboratory::Aliquot.new(parameters.merge!(:snp_assay => snp_assay)) }

        it "can have an snp assay" do
          store.with_session do |session|
            session.aliquot[aliquot_id].snp_assay.should == snp_assay
          end
        end
      end
    end

    pending "with sample and snp_assay" do
      it "can not have an snp assay and a sample simultaneously" do
        expect do
          store.with_session do |session|
            aliquot = Laboratory::Aliquot.new(parameters.merge!(
              :snp_assay => snp_assay, :sample => sample))
            session << aliquot
          end
        end.to raise_error(Sequel::ConstraintViolation)
      end

    end
  end
end
