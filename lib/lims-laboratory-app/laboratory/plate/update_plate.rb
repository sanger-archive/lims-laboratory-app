# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-laboratory-app/laboratory/plate'
require 'lims-laboratory-app/laboratory/container/update_container_action_trait'
require 'lims-core/actions/action'

module Lims::LaboratoryApp
  module Laboratory
    # Update a plate and set a new type and/or a new quantity to 
    # all its aliquots.
    class Plate
      class UpdatePlate
        include Lims::Core::Actions::Action

        # The plate to update
        attribute :plate, Laboratory::Plate, :required => true, :writer => :private
        # Type is the actual type of the plate, not the role in the order.
        attribute :type, String, :required => false, :writer => :private
        # @example:
        # {"A1" => {"sample" => sample_1, "aliquot_type" => "type", "aliquot_quantity" => 10}, ...}
        # Update the aliquot containing sample_1 with aliquot_type and aliquot_quantity.
        attribute :wells, Hash, :required => false, :writer => :private, :default => {}

        does "lims/laboratory_app/laboratory/container/update_container_action", {
          :container_name => "plate", :elements_name => "wells"
        }

        def _call_in_session(session)
          plate.type = type if type
          update(session)
        end
      end
    end
  end

  module Laboratory
    class Plate
      Update = UpdatePlate
    end
  end
end
