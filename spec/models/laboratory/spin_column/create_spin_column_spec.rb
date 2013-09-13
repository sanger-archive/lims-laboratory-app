# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'

#Model requirements
require 'lims-laboratory-app/laboratory/spin_column/create_spin_column'
require 'lims-laboratory-app/laboratory/tube/all'
require 'lims-laboratory-app/laboratory/spin_column/all'
require 'models/laboratory/tube_shared'
require 'lims-core/persistence/store'

module Lims::LaboratoryApp
  module Laboratory
    describe SpinColumn::CreateSpinColumn, :spin_column => true, :laboratory => true, :persistence => true do
      context "with a valid store" do
        include_context "create object"
        let (:store) { Lims::Core::Persistence::Store.new }
        include_context("for application", "Test create spin column")

        context "create an empty spin column" do
          subject do 
            SpinColumn::CreateSpinColumn.new(:store => store, :user => user, :application => application)  do |a,s|
            end
          end
          it_behaves_like "an action"
          it "create a spin column when called" do
            Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
            result = subject.call
            result.should be_a(Hash)
            result[:spin_column].should be_a(Laboratory::SpinColumn)
            result[:uuid].should == uuid
          end
        end

        context "create a spin column with samples" do
          let(:sample) { new_sample(1) }
          subject do 
            SpinColumn::CreateSpinColumn.new(:store => store, :user => user, :application => application, :aliquots => [{:sample => sample }]) do |a,s|
            end
          end
          it_behaves_like "an action"
          it "create a spin column when called" do
            Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
            result = subject.call
            result.should be_a(Hash)
            result[:spin_column].should be_a(Laboratory::SpinColumn)
            result[:uuid].should == uuid
            result[:spin_column].first.sample.should == sample
          end
        end
      end
    end
  end
end
