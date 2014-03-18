require 'lims-api/core_action_resource'

require 'lims-laboratory-app/laboratory/gel'
require 'lims-laboratory-app/laboratory/container/create_container_resource'

module Lims::LaboratoryApp
  module Laboratory
    class Gel
      class CreateGelResource < Lims::Api::CoreActionResource
        include Lims::LaboratoryApp::Laboratory::Container::CreateContainerResource

        def self.element_attr
          'windows_description'
        end

        def self.element_attr_sym
          :windows_description
        end
      end
    end
  end
end
