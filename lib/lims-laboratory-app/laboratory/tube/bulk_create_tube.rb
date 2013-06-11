require 'lims-core/actions/bulk_action'
require 'lims-laboratory-app/laboratory/tube'
require 'lims-laboratory-app/laboratory/tube/create_tube'

module Lims::LaboratoryApp
  module Laboratory
    class Tube
      class BulkCreateTube 
        include Lims::Core::Actions::BulkAction
        initialize_class(:tube, :tubes, CreateTube)
      end
    end
  end
end
