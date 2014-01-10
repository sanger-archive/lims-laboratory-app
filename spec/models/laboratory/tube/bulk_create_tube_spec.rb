# Spec requirements
require 'models/laboratory/spec_helper'
require 'models/actions/spec_helper'
require 'models/actions/action_examples'
require 'models/laboratory/location_shared'

#Model requirements
require 'lims-laboratory-app/laboratory/tube/bulk_create_tube'
require 'models/laboratory/tube_shared'
require 'lims-core/persistence/store'
require 'lims-laboratory-app/organization/location'

module Lims::LaboratoryApp
  module Laboratory
    describe Tube::BulkCreateTube, :tube => true, :laboratory => true, :persistence => true do
      context "with a valid store" do
        include_context "create object"
        include_context "define location"
        let(:store) { Lims::Core::Persistence::Store.new }
        let(:user) { double(:user) }
        let(:application) { "bulk create tube" }
        let(:types) { ["type1", "type2", "type3"] }
        let(:aliquot_types) { ["NA", "DNA", "RNA", "NAP"] }

        context "bulk create tubes" do
          subject do
            Tube::BulkCreateTube.new(:store => store, :user => user, :application => application) do |a,s|
              a.tubes = parameters
            end
          end


          context "empty tubes with location" do
            let(:parameters) do
              [].tap do |tubes|
                10.times do
                  tubes << {"type" => types[rand(3)], "max_volume" => rand(10), "location" => location}
                end
              end
            end

            it_behaves_like "an action"
            it "create 10 tubes" do
              Lims::Core::Persistence::Session.any_instance.should_receive(:save_all).and_call_original
              result = subject.call
              result.should be_a(Hash)
              result[:tubes].should be_a(Array)
              result[:tubes].size.should == 10
              result[:tubes].each_with_index do |tube,i|
                tube.should be_a(Tube)
                tube.type.should == parameters[i]["type"] 
                tube.max_volume.should == parameters[i]["max_volume"]
                tube.location.should == parameters[i]["location"]
              end
            end
          end

          context "tubes with samples and location" do
            let(:parameters) do
              [].tap do |tubes|
                10.times do
                  tubes << {
                    "type" => types[rand(3)],
                    "max_volume" => rand(10),
                    "location" => location,
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
            it "create 10 tubes" do
              Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
              result = subject.call
              result.should be_a(Hash)
              result[:tubes].should be_a(Array)
              result[:tubes].size.should == 10
              result[:tubes].each_with_index do |tube,i|
                tube.should be_a(Tube)
                tube.type.should == parameters[i]["type"] 
                tube.max_volume.should == parameters[i]["max_volume"] 
                tube.each_with_index do |aliquot, j|
                  aliquot[:sample].should == parameters[i]["aliquots"][j]["sample"]
                  aliquot[:type].should == parameters[i]["aliquots"][j]["type"]
                  aliquot[:quantity].should == parameters[i]["aliquots"][j]["quantity"]
                end
                tube.location.should == location
              end
            end
          end
        end
      end
    end
  end
end
