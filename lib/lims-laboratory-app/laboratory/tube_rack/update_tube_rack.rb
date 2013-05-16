# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/tube_rack'

module Lims::LaboratoryApp
  module Laboratory
    # Update a tube rack by updating each of its tube type or quantity.
    class TubeRack
      class UpdateTubeRack
        include Lims::Core::Actions::Action

        attribute :tube_rack, Laboratory::TubeRack, :required => true, :writer => :private
        attribute :aliquot_type, String, :required => false, :writer => :private
        attribute :aliquot_quantity, Numeric, :required => false, :writer => :private
        # @attribute [Hash<String, Laboratory::Tube>] tubes
        # @example
        # {"A1" => tube_1, "B4" => tube_2}
        attribute :tubes, Hash, :required => false, :writer => :private, :default => {}

        # Add the new tubes first then update all the tubes if needed 
        # with aliquot_type and aliquot_quantity.
        # If the position of the tube rack is not empty,
        # a RackPositionNotEmpty exception is raised.
        # @see Laboratory::TubeRack#[]=
        def _call_in_session(session)
          tubes.each do |location, tube|
            tube_rack[position] = tube 
          end

          tube_rack.each do |tube|
            if tube
              tube.each do |aliquot|
                aliquot.type = aliquot_type if aliquot_type
                aliquot.quantity = aliquot_quantity if aliquot_quantity
              end
            end
          end
          {:tube_rack => tube_rack}
        end
      end
    end
  end

  module Laboratory
    class TubeRack
      Update = UpdateTubeRack
    end
  end
end
