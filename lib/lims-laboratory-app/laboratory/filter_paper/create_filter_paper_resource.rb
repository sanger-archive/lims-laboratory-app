require 'lims-laboratory-app/laboratory/filter_paper'

require 'lims-api/core_action_resource'
require 'lims-api/resources/create_container'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      # This is the resource file for JSON representation of CreateFilterPaper
      # action. All of the common resource related method for creating
      # container objects (FilterPaper, Gel, Plate) has been implemented
      # in the CreateContainer module.
      class CreateFilterPaperResource < Lims::Api::CoreActionResource
        include Lims::Api::Resources::CreateContainer

        # This methods returns the proper container element name.
        # Returns a String type.
        def self.element_attr
          'locations_description'
        end

        def element_attr_sym
          :locations_description
        end

      end
    end
  end
end
