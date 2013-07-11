# Spec requirements
require 'models/actions/action_examples'
require 'models/actions/spec_helper'

# Model requirements
require 'lims-laboratory-app/labels/labellable/bulk_create_labellable'
require 'lims-laboratory-app/labels/labellable/all'

module Lims::LaboratoryApp
  module Labels
    describe Labellable::BulkCreateLabellable, :labellable => true, :labels => true, :persistence => true do
      context "with a valid store" do
        include_context "create object"
        let!(:store) { Lims::Core::Persistence::Store.new }
        include_context("for application", "Test create laballable")

        let(:labellable_checker) {
          lambda { |labellable|
            labellable.name.should_not be_empty
            labellable.name.should be_a(String)
            labellable.type.should_not be_empty
            labellable.type.should be_a(String)
          }
        }

        let(:names) { ["aaa", "bbb", "ccc", "ddd"] }
        let(:type) { "resource" }
        let(:label_types) { ["sanger-barcode", "ean13-barcode"] }
        let(:parameters) do
          [].tap do |labellables|
            10.times do
              labellables << {
                "name" => names[rand(4)], 
                "type" => type,
                "labels" => {
                  "front barcode" => {
                    "value" => rand(10000).to_s,
                    "type" => label_types[rand(2)]
                  }
                }
              }
            end
          end
        end

        context "bulk create labellables" do
          subject do
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.labellables = parameters
            end
          end

          it_behaves_like "an action"

          it "creates 10 labellables" do
            Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
            result = subject.call
            result.should be_a(Hash)
            result[:labellables].should be_a(Array)
            result[:labellables].size.should == 10
            result[:labellables].each_with_index do |labellable, i|
              labellable.should be_a(Labellable)
              labellable_checker[labellable]
              labellable.name.should == parameters[i]["name"]
              labellable.type.should == parameters[i]["type"]
              labellable.labels.each do |label|
                label.type.should == parameters[i]["labels"]["front barcode"]["type"]
                label.value.should == parameters[i]["labels"]["front barcode"]["value"]
              end
            end
          end
        end
      end
    end
  end
end
