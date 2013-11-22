require 'models/actions/spec_helper'
require 'models/actions/action_examples'
require 'models/laboratory/tube_shared'
require 'models/laboratory/filter_paper_shared'

require 'lims-laboratory-app/laboratory/filter_paper/bulk_create_filter_paper'
require 'lims-core/persistence/store'

module Lims::LaboratoryApp
  module Laboratory
    describe FilterPaper::BulkCreateFilterPaper, :filter_paper => true, :laboratory => true, :persistence => true do
      context "with a valid store" do
        include_context "create object"
        let(:store) { Lims::Core::Persistence::Store.new }
        let(:user) { double(:user) }
        let(:application) { "bulk create filter paper" }
        let(:aliquot_types) { ["NA", "DNA", "RNA", "NAP"] }

        # define parameters for the action
        let(:number_of_filter_papers) { 5 }

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
                  filter_papers << {}
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
              end
            end
          end

          context "filter papers with samples" do
            let(:parameters) do
              [].tap do |filter_papers|
                number_of_filter_papers.times do
                  filter_papers << {
                    "aliquots" => [{
                      "sample" => new_sample(rand(50)), 
                      "type" => aliquot_types[rand(3)], 
                      "quantity" => rand(40)
                    }]
                  } 
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
              result[:filter_papers].each_with_index do |filter_paper,i|
                filter_paper.should be_a(FilterPaper)
                filter_paper.each_with_index do |aliquot, j|
                  aliquot[:sample].should == parameters[i]["aliquots"][j]["sample"]
                  aliquot[:type].should == parameters[i]["aliquots"][j]["type"]
                  aliquot[:quantity].should == parameters[i]["aliquots"][j]["quantity"]
                end
              end
            end
          end
        end
      end
    end
  end
end
