#spin_column_resource.rb
require 'lims-api/core_resource'
require 'lims-api/struct_stream'
require 'lims-api/resources/receptacle'

require 'lims-laboratory-app/labellable_core_resource'
require 'lims-laboratory-app/laboratory/spin_column'

module Lims::LaboratoryApp
  module Laboratory
    class SpinColumn
      class SpinColumnResource < LabellableCoreResource

        include Lims::Api::Resources::Receptacle

        def content_to_stream(s, mime_type)
          s.add_key "aliquots"
          receptacle_to_stream(s, object, mime_type)
        end
      end
    end
  end
end
