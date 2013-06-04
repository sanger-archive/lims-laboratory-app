require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/tube'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      class TransferMultipleFilterPapersToTubes
        include Lims::Core::Actions::Action

        attribute :transfers, Hash, :required => true, :writer => :private

        def _call_in_session(session)
          targets = []
          transfers.each do |transfer|
            source = transfer["source"]
            source_location = transfer["source_location"]
            target_tube = transfer["target"]

            target_tube << source[source_location]
            targets << target_tube
          end

          { :targets => targets }
        end
      end
    end
  end
end
