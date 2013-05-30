# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/tube'
require 'lims-laboratory-app/laboratory/tube/create_tube_shared'

module Lims::LaboratoryApp
  module Laboratory
    class Tube
      class CreateTube
        include Lims::Core::Actions::Action
        include CreateTubeShared

        attribute :aliquots, Array, :default => []
        attribute :type, String, :required => false, :writer => :private
        attribute :max_volume, Numeric, :required => false, :writer => :private

        def initialize(*args, &block)
          @name = "Create Tube"
          super(*args, &block)
        end

        def _call_in_session(session)
          _create(type, max_volume, aliquots, session)
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
