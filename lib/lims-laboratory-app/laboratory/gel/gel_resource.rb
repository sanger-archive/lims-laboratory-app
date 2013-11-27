#gel_resource.rb
require 'lims-laboratory-app/laboratory/container/receptacle'
require 'lims-laboratory-app/laboratory/container/children_to_stream'
require 'lims-api/core_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/labellable_core_resource'
require 'lims-laboratory-app/laboratory/gel'

module Lims::LaboratoryApp
  module Laboratory
    class Gel
      class GelResource < LabellableCoreResource

        include Lims::LaboratoryApp::Laboratory::Container::Receptacle
        include Lims::LaboratoryApp::Laboratory::Container::ChildrenToStream

        def elements_name
          "windows"
        end
      end
    end
  end
end
