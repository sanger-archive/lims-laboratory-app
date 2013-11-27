#tube_resource.rb
require 'lims-api/core_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/laboratory/tube'
require 'lims-laboratory-app/laboratory/container/receptacle'

module Lims::LaboratoryApp
  module Laboratory
    class Tube
      class TubeResource < Lims::Api::CoreResource

        include Lims::LaboratoryApp::Laboratory::Container::Receptacle

        def content_to_stream(s, mime_type)
          super(s, mime_type)
          s.add_key "aliquots"
          receptacle_to_stream(s, object, mime_type)
        end

      end
    end
  end
end
