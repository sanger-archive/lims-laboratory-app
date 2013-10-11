require 'lims-laboratory-app/laboratory/filter_paper'

require 'lims-api/resources/receptacle'
require 'lims-api/resources/container'
require 'lims-api/core_resource'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      # This is the resource file for JSON representation of a Filter Paper.
      # The JSON representation of the samples are in the Receptacle module.
      # All of the common resource related method for container objects
      # (FilterPaper, Gel, Plate) has been implemented in the Container module.
      class FilterPaperResource < Lims::Api::CoreResource

        include Lims::Api::Resources::Receptacle
        include Lims::Api::Resources::Container

        # this method define the name of the elements of this container
        def elements_name
          "locations"
        end

      end
    end
  end
end
