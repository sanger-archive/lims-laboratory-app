#tube_resource.rb
require 'lims-api/core_resource'
require 'lims-api/struct_stream'
require 'lims-api/resources/receptacle'

require 'lims-laboratory-app/labels/labellable/labelled_resource'
require 'lims-laboratory-app/laboratory/tube'

module Lims::LaboratoryApp
  module Laboratory
    class Tube
      class TubeResource < Lims::Api::CoreResource

        include Lims::Api::Resources::Receptacle
        include Labels::Labellable::LabelledResource

        def content_to_stream(s, mime_type)
          super(s, mime_type)
          s.add_key "aliquots"
          receptacle_to_stream(s, object, mime_type)
          labellable_to_stream(s, mime_type) 
        end
      end
    end
  end
end
