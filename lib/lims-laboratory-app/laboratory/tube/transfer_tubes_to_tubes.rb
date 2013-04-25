require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/transfer_action'
require 'lims-laboratory-app/laboratory/transfers_parameters'

require 'lims-laboratory-app/laboratory/spin_column'
require 'lims-laboratory-app/laboratory/tube'

module Lims::LaboratoryApp
  module Laboratory

    # This {Action} transfers the given fraction and type of aliquot from tube-like asset(s)
    # to tube-like asset(s).
    # It takes an array, which contains transfer elements. 
    # An element has a source, target, amount, fraction and type parameter.
    # Source and targets are tube-like assets (a tube or spin column).
    # Amount is an amount of an aliquot to transfer.
    # Fraction is the fraction of an aliquot to transfer.
    # Type is the type of the aliquot.
    class Tube
      class TransferTubesToTubes
        include Lims::Core::Actions::Action
        include TransferAction
        include TransfersParameters

        # transfer the given fraction of aliquot from tube-like asset(s)
        # to tube-like asset(s)
        def _call_in_session(session)

          _transfer(transfers, _amounts(transfers), session)

        end
      end
    end
  end
end
