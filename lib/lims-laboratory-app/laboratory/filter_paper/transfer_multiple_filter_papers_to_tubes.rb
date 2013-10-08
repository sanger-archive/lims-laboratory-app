require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/transfer_action'
require 'lims-laboratory-app/laboratory/tube'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      class TransferMultipleFilterPapersToTubes
        include Lims::Core::Actions::Action
        include TransferAction

        attribute :transfers, Hash, :required => true, :writer => :private

        def _call_in_session(session)
          _transfer(transfers, _amounts(transfers), session)
        end

      end
    end
  end
end
