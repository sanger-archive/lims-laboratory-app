#gel_resource.rb
require 'lims-api/resources/receptacle'
require 'lims-api/resources/container'
require 'lims-api/core_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/labels/labellable/labelled_resource'
require 'lims-laboratory-app/laboratory/gel'

module Lims::LaboratoryApp
  module Laboratory
    class Gel
      class GelResource < Lims::Api::CoreResource

        include Lims::Api::Resources::Receptacle
        include Lims::Api::Resources::Container
        include Labels::Labellable::LabelledResource

        def elements_name
          "windows"
        end

        def content_to_stream(s, mime_type)
          super(s, mime_type)
          labellable_to_stream(s, mime_type)
        end
      end
    end
  end
end
