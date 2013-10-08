require 'lims-laboratory-app/laboratory/filter_paper/create_filter_paper'
require 'models/actions/spec_helper'
require 'models/actions/action_examples'
require 'models/laboratory/aliquot_shared'

module Lims::LaboratoryApp
  module Laboratory
    shared_context "for empty filter paper" do
      subject do
        FilterPaper::Create.new(:store => store, :user => user, :application => application) do |action, session|
          parameters.each do |key, value|
            action.send("#{key}=", value)
          end
        end
      end

      let (:filter_paper_content_checker) do
        lambda do |filter_paper|
          filter_paper.each { |location| location.should be_empty }
        end
      end
    end

    shared_context "for filter paper with some sample" do
      let(:locations_description_value) do
        {}.tap do |descriptions|
          1.upto(number_of_rows) do |row|
            1.upto(number_of_columns) do |column|
              descriptions[FilterPaper.indexes_to_element_name(row-1, column-1)] = [
                {:sample => new_sample(row, column), :quantity => 1}
                ]
            end
          end
        end
      end
      let(:locations_description) { {
        :locations_description => locations_description_value
      } }

      subject do
        FilterPaper::CreateFilterPaper.new(:store => store, :user => user, :application => application) do |action, session|
          parameters.merge(locations_description).each do |key, value|
            action.send("#{key}=", value)
          end
        end
      end

      let (:filter_paper_content_checker) do
        lambda do |filter_paper|
          filter_paper.each do |location|
            location.should_not be_empty
          end
          locations_description_value.each do |location_key, expected_aliquots|
            aliquot_from_created_filter_paper = filter_paper[location_key]
            aliquot_from_created_filter_paper.size.should == 1
            aliquot_from_created_filter_paper.first.sample.should == expected_aliquots.first[:sample]
          end

        end
      end
    end

    shared_examples_for "creating a filter paper" do
      include_context "create object"
      it_behaves_like "an action"

      it "creates a filter paper when called" do
        result = subject.call()
        result.should be_a(Hash)
        result[:uuid] = uuid
        filter_paper = result[:filter_paper]

        filter_paper_content_checker[filter_paper]
        filter_paper.number_of_rows.should == number_of_rows
        filter_paper.number_of_columns.should == number_of_columns
        filter_paper.size.should == size
      end
    end

    describe FilterPaper::CreateFilterPaper do
      let!(:store) { Lims::Core::Persistence::Store.new() }

      # define parameters for the action
      let(:number_of_rows) { 2 }
      let(:number_of_columns) { 2 }
      let(:size) { number_of_rows * number_of_columns }
      let(:parameters) { {
        :number_of_rows     => number_of_rows,
        :number_of_columns  => number_of_columns
      } }

      include_context("for application",  "Test filter paper creation")

      context do
        include_context('for empty filter paper')
        it_behaves_like('creating a filter paper')
      end

      context do
        include_context('aliquot factory')
        include_context('for filter paper with some sample')
        it_behaves_like('creating a filter paper')
      end
    end
  end
end
