require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-laboratory-app/laboratory/plate'
require 'lims-laboratory-app/laboratory/transfer_action'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      # This action transfer the content from 1 or more locations 
      # on a filter paper to 1 or more wells on a plate
      class TransferMultipleFilterPapersToWells
        include Lims::Core::Actions::Action
        include TransferAction

        attribute :transfers, Hash, :required => true, :writer => :private

        def _call_in_session(session)
          targets = []
          transfers.each do |transfer|
            source = transfer["source"]
            source_location = transfer["source_location"]
            target_plate = transfer["target"]
            target_location = transfer["target_location"]

            target_plate[target_location] << source[source_location].take_fraction(1)
            targets << target_plate
          end

          { :targets => targets }
        end

      end
    end
  end
end
