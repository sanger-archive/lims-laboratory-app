require 'lims-laboratory-app/laboratory/fluidigm'
require 'lims-laboratory-app/laboratory/fluidigm/fluidigm_persistor'
require 'lims-laboratory-app/laboratory/container/create_container_action_trait'

module Lims::LaboratoryApp
  module Laboratory
    class Fluidigm
      class CreateFluidigm
        include Lims::Core::Actions::Action

        # @attribute [Hash<String, Array<Hash>>] fluidigm_wells_description
        # @example
        #   { "A1" => [{ :sample => s1, :quantity => 2}, {:sample => s2}] }
        attribute :fluidigm_wells_description, Hash, :default => {}

        does "lims/laboratory_app/laboratory/container/create_container_action", {
          :container_name => "fluidigm",
          :container_class => Laboratory::Fluidigm,
          :element_description_name => "fluidigm_wells_description"
        }
      end

      Create = CreateFluidigm

    end
  end
end
