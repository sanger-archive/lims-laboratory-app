require 'models/actions/spec_helper'
require 'models/actions/action_examples'
require 'models/laboratory/tube_shared'
require 'models/laboratory/filter_paper_shared'

require 'lims-laboratory-app/laboratory/filter_paper/create_filter_paper'
require 'lims-core/persistence/store'

module Lims::LaboratoryApp
  module Laboratory
    describe FilterPaper::CreateFilterPaper, :filter_paper => true, :laboratory => true, :persistence => true do
      context "with a valid store" do
        include_context "create object"
        let (:store) { Lims::Core::Persistence::Store.new }
        let(:user) { double(:user) }
        let(:application) { "Test create filter paper" }

        context "create an empty filter paper" do
          subject do
            FilterPaper::CreateFilterPaper.new(:store => store, :user => user, :application => application)  do |a,s|
            end
          end 
          it_behaves_like "an action"

          it "create a filter paper when called" do
            Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
            result = subject.call
            result.should be_a(Hash)
            result[:filter_paper].should be_a(Laboratory::FilterPaper)
            result[:uuid].should == uuid
          end
        end

        context "create a filter paper with samples" do
          let(:sample) { new_sample(1) }
          subject do 
            FilterPaper::CreateFilterPaper.new(:store => store, :user => user, :application => application) do |a,s|
              a.aliquots = [{:sample => sample }] 
            end
          end
          it_behaves_like "an action"
          it "create a filter paper when called" do
            Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
            result = subject.call
            result.should be_a(Hash)
            result[:filter_paper].should be_a(Laboratory::FilterPaper)
            result[:uuid].should == uuid
            result[:filter_paper].first.sample.should == sample
          end
        end
      end
    end
  end
end

