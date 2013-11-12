require 'lims-laboratory-app/laboratory/fluidigm'
require 'lims-laboratory-app/laboratory/fluidigm/fluidigm_persistor'
require 'lims-laboratory-app/laboratory/container/create_container_action'

module Lims::LaboratoryApp
  module Laboratory
    class Fluidigm
      class CreateFluidigm
        include Container::CreateContainerAction

        # @attribute [Hash<String, Array<Hash>>] wells_description
        # @example
        #   { "A1" => [{ :sample => s1, :quantity => 2}, {:sample => s2}] }
        attribute :wells_description, Hash, :default => {}

        def container_class
          Laboratory::Fluidigm
        end

        def element_description
          wells_description
        end

        def container_symbol
          :fluidigm
        end
      end

      Create = CreateFluidigm

    end
  end
end
