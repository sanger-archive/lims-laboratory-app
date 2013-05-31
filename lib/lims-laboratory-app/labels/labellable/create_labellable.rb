# create_labellable.rb
require 'lims-core/actions/action'
require 'lims-laboratory-app/labels/labellable'
require 'lims-laboratory-app/labels/labellable/create_labellable_shared'

module Lims::LaboratoryApp
  module Labels
    class Labellable
      class CreateLabellable
        include Lims::Core::Actions::Action
        include CreateLabellableShared

        attribute :name, String, :required => true, :writer => :private, :initializable => true
        attribute :type, String, :required => true, :writer => :private, :initializable => true
        attribute :labels, Hash, :default => {}, :writer => :private, :initializable => true

        def _call_in_session(session)
          _create(name, type, labels, session)
        end
      end
    end
  end
  module Labels
    class Labellable
      Create = CreateLabellable
    end
  end
end
