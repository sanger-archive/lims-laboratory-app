require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/tube'

module Lims::LaboratoryApp
  module Laboratory
    class Tube
      class DeleteTube
        include Lims::Core::Actions::Action

        attribute :tube, Laboratory::Tube, :required => true, :writer => :private

        def _call_in_session(session)
          session.delete(tube)

          {:tube => tube}
        end
      end
    end
  end

  module Laboratory
    class Tube
      Delete = DeleteTube
    end
  end
end
