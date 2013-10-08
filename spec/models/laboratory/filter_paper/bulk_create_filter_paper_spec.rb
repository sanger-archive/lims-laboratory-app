require 'models/actions/spec_helper'
require 'models/actions/action_examples'

require 'lims-laboratory-app/laboratory/filter_paper/bulk_create_filter_paper'
require 'lims-core/persistence/store'

module Lims::LaboratoryApp
  module Laboratory
    describe FilterPaper::BulkCreateFilterPaper do
      context "with a valid store" do
        include_context "create object"
        let(:store) { Lims::Core::Persistence::Store.new }
        let(:user) { mock(:user) }
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
                5.times do
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
              result[:filter_papers].size.should == 5
              # TODO ke4 add random filter paper creation
            end
          end

        end
      end
    end
  end
end