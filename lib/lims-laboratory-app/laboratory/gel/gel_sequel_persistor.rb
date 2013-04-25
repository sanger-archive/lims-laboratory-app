require 'lims-laboratory-app/laboratory/gel/gel_persistor'
require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/laboratory/container/container_sequel_persistor'
require 'lims-laboratory-app/laboratory/container/container_element_sequel_persistor'

module Lims::LaboratoryApp
  module Laboratory
    # A gel persistor. It saves the gel's data to the DB.
    class Gel
      # A window persistor. It saves the window's data to the DB.
      class Window
        class WindowSequelPersistor< WindowPersistor
          include Lims::Core::Persistence::Sequel::Persistor
          include Container::ContainerElementSequelPersistor

          def self.table_name
            :windows
          end

          def container_id_sym
            :gel_id
          end

        end 
      end
      #class Window

      class GelSequelPersistor < GelPersistor
        include Lims::Core::Persistence::Sequel::Persistor
        include Container::ContainerSequelPersistor

        def self.table_name
          :gels
        end

        def container_id_sym
          :gel_id
        end
      end
    end
  end
end
