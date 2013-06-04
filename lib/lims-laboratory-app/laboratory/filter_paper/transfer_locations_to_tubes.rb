require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/tube'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      # This action transfer the content from 1 or more locations 
      # on a filter paper to 1 or more tubes
      class TransferLocationsToTubes
        include Lims::Core::Actions::Action

        attribute :source, FilterPaper, :required => true, :writer => :private
        attribute :transfers, Hash, :required => true, :writer => :private

        def _call_in_session(session)
          targets = []
          transfers.each do |transfer|
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
