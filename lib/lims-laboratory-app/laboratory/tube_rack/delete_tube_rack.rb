require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/tube_rack'

module Lims::LaboratoryApp
  module Laboratory
    class TubeRack
      class DeleteTubeRack
        include Lims::Core::Actions::Action

        attribute :tube_rack, Laboratory::TubeRack, :required => true, :writer => :private

        def _call_in_session(session)
          session.delete(tube_rack)

          {:tube_rack => tube_rack}
        end
      end
    end
  end

  module Laboratory
    class TubeRack
      Delete = DeleteTubeRack
    end
  end
end
