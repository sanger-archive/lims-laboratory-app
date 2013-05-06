require 'lims-api/core_action_resource'
require 'lims-api/resources/create_container'

require 'lims-laboratory-app/laboratory/plate'

module Lims::LaboratoryApp
  module Laboratory
    class Plate
      class CreatePlateResource < Lims::Api::CoreActionResource
        include Lims::Api::Resources::CreateContainer

        def self.element_attr
          'wells_description'
        end

        def self.element_attr_sym
          :wells_description
        end
      end
    end
  end
end
