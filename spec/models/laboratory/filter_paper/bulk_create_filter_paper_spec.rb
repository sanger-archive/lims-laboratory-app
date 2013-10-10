require 'models/actions/spec_helper'
require 'models/actions/action_examples'
require 'models/laboratory/aliquot_shared'

require 'lims-laboratory-app/laboratory/filter_paper/bulk_create_filter_paper'
require 'lims-core/persistence/store'
require 'lims-laboratory-app/laboratory/filter_paper/all'

module Lims::LaboratoryApp
  module Laboratory
    describe FilterPaper::BulkCreateFilterPaper do
      context "with a valid store" do
        include_context "create object"
        let(:store) { Lims::Core::Persistence::Store.new }
        let(:user) { double(:user) }
        let(:application) { "bulk create filter paper" }

        # define parameters for the action
        let(:number_of_rows) { 2 }
        let(:number_of_columns) { 2 }
        let(:size) { number_of_rows * number_of_columns }
        let(:number_of_filter_papers) { 5 }
        let(:create_parameters) { {
          "number_of_rows"     => number_of_rows,
          "number_of_columns"  => number_of_columns
        } }


        context "bulk create filter papers" do
          subject do
            FilterPaper::BulkCreateFilterPaper.new(
              :store        => store,
              :user         => user,
              :application  => application) do |action, session|
              action.filter_papers = parameters
            end
          end

          context "empty filter papers" do
            let(:parameters) do
              [].tap do |filter_papers|
                number_of_filter_papers.times do
                  filter_papers << create_parameters
                end
              end
            end

            it_behaves_like "an action"
            it "creates 5 filter papers" do
              Lims::Core::Persistence::Session.any_instance.should_receive(:save_all).and_call_original
              result = subject.call
              result.should be_a(Hash)
              result[:filter_papers].should be_a(Array)
              result[:filter_papers].size.should == number_of_filter_papers
              result[:filter_papers].each do |filter_paper|
                filter_paper.should be_a(FilterPaper)
                filter_paper.number_of_rows.should == number_of_rows
                filter_paper.number_of_columns.should == number_of_columns
              end
            end
          end

          context "tubes with samples" do
            include_context('aliquot factory')
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
            let(:parameters) do
              create_parameters.merge!(locations_description)
              [].tap do |filter_papers|
                number_of_filter_papers.times do
                  filter_papers << create_parameters
                end
              end
            end

          it_behaves_like "an action"
           it "create 5 filter papers" do
             Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
             result = subject.call
             result.should be_a(Hash)
             result[:filter_papers].should be_a(Array)
             result[:filter_papers].size.should == number_of_filter_papers
             result[:filter_papers].each do |filter_paper|
               filter_paper.should be_a(FilterPaper)
               filter_paper.number_of_rows.should == number_of_rows
               filter_paper.number_of_columns.should == number_of_columns
               filter_paper.each_with_index do |location, i|
                 k = 0
                 location.each_with_index do |aliquot, j|
                   aliquot[:sample].should == parameters[k][:locations_description][i][j][:sample]
                   aliquot[:type].should == parameters[k][:locations_description][i][j][:type]
                   aliquot[:quantity].should == parameters[k][:locations_description][i][j][:quantity]
                 end
                 k += 1
               end
             end
           end
          end

        end
      end
    end
  end
end