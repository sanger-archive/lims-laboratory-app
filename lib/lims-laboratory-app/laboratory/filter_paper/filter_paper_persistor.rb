require 'lims-core/persistence/persistor'
require 'lims-laboratory-app/laboratory/filter_paper'

require 'lims-laboratory-app/laboratory/container/container_persistor'
require 'lims-laboratory-app/laboratory/container/container_element_persistor'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      # This is the persister class of the Filter Paper class.
      # All of the common persistence related method for container objects
      # (Filter Paper, Gel, Plate) have been implemented in common modules.
      class FilterPaperPersistor < Lims::Core::Persistence::Persistor
        Model = Laboratory::FilterPaper

        include Container::ContainerPersistor

        # this method define the name of the element of this container
        def element
          location
        end

        def location
          @session.filter_paper_location
        end
      end

      # This is the persister class of the Location class.
      class Location
        # Register the LocationPersistor to the {Session}
        SESSION_NAME = :filter_paper_location

        class LocationPersistor < Lims::Core::Persistence::Persistor
          Model = Laboratory::FilterPaper::Location

          include Container::ContainerElementPersistor

        end
      end
    end
  end
end
