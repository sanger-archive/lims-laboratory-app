#create_flowcell.rb
require 'lims-laboratory-app/laboratory/flowcell'
require 'lims-laboratory-app/laboratory/create_labellable_resource_action'

module Lims::LaboratoryApp
  module Laboratory
    class Flowcell
      class CreateFlowcell
        include CreateLabellableResourceAction

        attribute :number_of_lanes, Fixnum, :required => true, :gte => 0, :writer => :private

        # @attribute [Hash<String>, Array<Hash>>] lanes_description
        # @example
        #   { "1" => [{ :sample => s1, :quantity => 2}, {:sample => s2}] }
        # # the keys are a String and start a 1 for the firt lane.
        attribute :lanes_description, Hash, :default => {}
        attribute :location, Organization::Location, :default => nil

        def create(session)
          flowcell = Laboratory::Flowcell.new(
            :number_of_lanes  => number_of_lanes,
            :location         => location
          )
          session << flowcell
          lanes_description.each do |lane_name, aliquots|
            aliquots.each do |aliquot|
              flowcell[lane_name.to_i-1] <<  Laboratory::Aliquot.new(aliquot)
            end
          end
          { :flowcell => flowcell, :uuid => session.uuid_for!(flowcell) }
        end
      end
    end
  end
  module Laboratory
    class Flowcell
      Create = CreateFlowcell
    end
  end
end
