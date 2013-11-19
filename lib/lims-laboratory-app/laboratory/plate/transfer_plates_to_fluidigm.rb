require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/transfer_action'
require 'lims-laboratory-app/laboratory/transfers_parameters'
require 'lims-laboratory-app/laboratory/plate/transfer_plates_to_plates'

module Lims::LaboratoryApp
  module Laboratory

    class Plate

      class TransferPlatesToFluidigm
        include Lims::Core::Actions::Action
        include TransferAction
        include TransfersParameters

        # transfer the given fraction of aliquot from plate-like asset(s)
        # to a fluidigm
        def _call_in_session(session)
          _transfer(transfers, _amounts(transfers), session)
        end

      end

    end
  end
end
