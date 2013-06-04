# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/tube'
require 'lims-laboratory-app/laboratory/tube/create_tube_shared'
require 'lims-laboratory-app/labels/create_labellable_resource'

module Lims::LaboratoryApp
  module Laboratory
    class Tube
      class CreateTube
        include Lims::Core::Actions::Action
        include CreateTubeShared
        include Lims::LaboratoryApp::Labels::CreateLabellableResource

        attribute :aliquots, Array, :default => []
        attribute :type, String, :required => false
        attribute :max_volume, Numeric, :required => false

        def initialize(*args, &block)
          @name = "Create Tube"
          super(*args, &block)
        end

        def create(session)
          createTube(type, max_volume, aliquots, session)
        end
      end
    end
  end
  module Laboratory
    class Tube
      Create = CreateTube
    end
  end
end
