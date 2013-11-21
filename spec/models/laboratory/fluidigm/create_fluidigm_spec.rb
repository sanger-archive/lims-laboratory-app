# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'

require 'models/laboratory/container_like_asset_shared'

#Model requirements
require 'lims-laboratory-app/laboratory/fluidigm/all'
require 'lims-laboratory-app/laboratory/snp_assay/all'
require 'lims-laboratory-app/laboratory/fluidigm/create_fluidigm'

module Lims::LaboratoryApp
  module Laboratory
    shared_context "for empty fluidigm" do
      let(:fluidigm_wells_description) { {} }
    end

    shared_context "empty fluidigm checker" do
      let(:fluidigm_checker) do
        lambda do |fluidigm|
          fluidigm.each  { |w| w.should be_empty }
        end
      end
    end

    shared_context "for a 12*16 well's fluidigm with a map of samples" do
      let(:fluidigm_wells_description) do
        {}.tap do |h|
          0.upto(number_of_rows-2) do |row|
            1.upto(number_of_columns/2) do |column|
              h["A#{row*number_of_columns/2+column}"] = [{
                :snp_assay => new_snp_assay(row, column),
                :quantity => nil
              }]
            end
            1.upto(number_of_columns/2) do |column|
              h["S#{row*number_of_columns/2+column}"] = [{
                :sample => new_sample(row, column),
                :quantity => nil
              }]
            end
          end
        end
      end
    end

    shared_context "for a 14*16 well's fluidigm with a map of samples" do
      let(:fluidigm_wells_description) do
        {}.tap do |h|
          1.upto(192) do |index|
            h["S#{index}"] = [{
              :sample => new_sample(index),
              :quantity => nil
            }]
          end
          1.upto(24) do |index|
            h["A#{index}"] = [{
              :snp_assay => new_snp_assay(index),
              :quantity => nil
            }]
          end
        end
      end
    end

    shared_context "fluidigm with content checker" do
      let(:fluidigm_checker) do
        lambda do |fluidigm|
          fluidigm_wells_description.each do |well_name, expected_aliquots|
            aliquots = fluidigm[well_name]
            aliquots.size.should == 1
            if well_name[0] == "S" # well contains a Sample
              aliquots.first.sample.should_not be_nil
              aliquots.first.sample.should == expected_aliquots.first[:sample]
            elsif well_name[0] == "A" # well contains a SNP Assay
              aliquots.first.snp_assay.should_not be_nil
              aliquots.first.snp_assay.should == expected_aliquots.first[:snp_assay]
            end
          end
        end
      end
    end

    shared_examples_for "creating a fluidigm" do
      include_context "create object"
      it_behaves_like "an action"
      it "creates a fluidigm when called" do
        result = subject.call()
        result.should be_a(Hash)

        fluidigm = result[:fluidigm]
        fluidigm.number_of_rows.should == number_of_rows
        fluidigm.number_of_columns.should == number_of_columns
        fluidigm_checker[fluidigm]

        result[:uuid].should == uuid
      end
    end

    shared_context "has fluidigm dimension" do |row, col|
      let(:number_of_rows) { row }
      let(:number_of_columns) { col }
    end

    describe Fluidigm::CreateFluidigm, :fluidigm => true, :laboratory => true, :persistence => true do
      context "valid calling context" do
        let!(:store) { Lims::Core::Persistence::Store.new() }
        include_context "container-like asset factory"
        include_context("for application",  "Test fluidigm creation")

        subject do
          Fluidigm::CreateFluidigm.new(:store => store, :user => user, :application => application)  do |a,s|
            a.number_of_rows    = number_of_rows
            a.number_of_columns = number_of_columns
            a.fluidigm_wells_description = fluidigm_wells_description
          end
        end


        context do
          include_context("has fluidigm dimension", 16, 12)

          context do
            include_context "for empty fluidigm"
            include_context "empty fluidigm checker"
            it_behaves_like('creating a fluidigm')
          end
          context do
            include_context "for a 12*16 well's fluidigm with a map of samples"
            include_context "fluidigm with content checker"
            it_behaves_like('creating a fluidigm')
          end
        end

        context do
          include_context("has fluidigm dimension", 16, 14)

          context do
            include_context "for empty fluidigm"
            include_context "empty fluidigm checker"
            it_behaves_like('creating a fluidigm')
          end
          context do
            include_context "for a 14*16 well's fluidigm with a map of samples"
            include_context "fluidigm with content checker"
            it_behaves_like('creating a fluidigm')
          end
        end
      end
    end
  end
end
