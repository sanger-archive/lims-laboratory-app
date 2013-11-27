#plate_resource.rb
require 'lims-api/resources/receptacle'
require 'lims-api/resources/container'
require 'lims-api/core_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/labels/labellable/api_labellable_resource'
require 'lims-laboratory-app/laboratory/plate'
module Lims::LaboratoryApp
  module Laboratory
    class Plate
      class PlateResource < Lims::Api::LabellableResource

        include Lims::Api::Resources::Receptacle
        include Lims::Api::Resources::Container

        def elements_name
          "wells"
        end

      end
    end
  end
end
