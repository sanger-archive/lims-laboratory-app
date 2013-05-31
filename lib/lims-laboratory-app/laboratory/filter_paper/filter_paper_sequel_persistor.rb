require 'lims-laboratory-app/laboratory/filter_paper/filter_paper_persistor'
require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/laboratory/container/container_sequel_persistor'
require 'lims-laboratory-app/laboratory/container/container_element_sequel_persistor'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      # The Sequel persister of the Filter Paper class.
      # It saves the Filter Paper's data to the DB.
      # All of the common Sequel persistence related method for container
      # objects (Filter Paper, Gel, Plate) have been implemented
      # in common modules.
      class FilterPaperSequelPersistor < FilterPaperPersistor
        include Lims::Core::Persistence::Sequel::Persistor
        include Container::ContainerSequelPersistor

        def self.table_name
          :filter_papers
        end

        # defines the proper container_id (filter_paper_id) with symbol type
        def container_id_sym
          :filter_paper_id
        end
      end

      class Location
        # The Sequel persister of the Location class.
        # It saves the Location's data to the DB.
        class LocationSequelPersistor < LocationPersistor
          include Lims::Core::Persistence::Sequel::Persistor
          include Container::ContainerElementSequelPersistor

          def self.table_name
            :locations
          end

          # defines the proper container_id (filter_paper_id) with symbol type
          def container_id_sym
            :filter_paper_id
          end
        end
      end
    end
  end
end
