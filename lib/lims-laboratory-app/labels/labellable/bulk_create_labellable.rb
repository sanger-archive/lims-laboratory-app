require 'lims-core/actions/bulk_action'
require 'lims-laboratory-app/labels/labellable/create_labellable'

module Lims::LaboratoryApp
  module Labels
    class Labellable
      class BulkCreateLabellable
        include Lims::Core::Actions::BulkAction
        initialize_class(:labellable, :labellables, CreateLabellable)
        def call(*args, &block)
          debugger
          super(*args, &block)
        end
      end
    end
  end
end
