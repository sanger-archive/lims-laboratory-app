# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-laboratory-app/laboratory/plate'
require 'lims-laboratory-app/laboratory/container/create_container_action_trait'

module Lims::LaboratoryApp
  module Laboratory
    class Plate
      class CreatePlate

        does "lims/laboratory_app/laboratory/container/create_container_action", {
          :container_name => "plate",
          :container_class => Laboratory::Plate,
          :element_description_name => :wells_description,
          :extra_parameters => [:type]
        }

        # @attribute [Hash<String, Array<Hash>>] wells_description
        # @example
        #   { "A1" => [{ :sample => s1, :quantity => 2}, {:sample => s2}] }
        attribute :wells_description, Hash, :default => {}
        # Type is the actual type of the plate, not the role in the order.
        attribute :type, String, :required => false, :writer => :private 
      end
    end
  end

  module Laboratory
    class Plate
      Create = CreatePlate
    end
  end
end
