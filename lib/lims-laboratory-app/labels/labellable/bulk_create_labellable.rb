require 'lims-core/actions/action'
require 'lims-laboratory-app/labels/labellable'
require 'lims-laboratory-app/labels/labellable/create_labellable_shared'

module Lims::LaboratoryApp
  module Labels
    class Labellable
      class BulkCreateLabellable
        include Lims::Core::Actions::Action
        include CreateLabellableShared

        attribute :labellables, Array, :required => true, :writer => :private

        def _call_in_session(session)
          result = []
          labellables.each do |parameters|
            result << _create(parameters["name"], parameters["type"], parameters["labels"], session)
          end

          {:labellables => result.map { |e| e[:labellable] }}
        end
      end
    end
  end
end
