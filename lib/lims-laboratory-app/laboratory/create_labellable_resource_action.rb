# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-laboratory-app/labels/labellable/create_labellable_shared'
require 'lims-core/actions/action'
module Lims::LaboratoryApp
  module Laboratory
    module CreateLabellableResourceAction
      def self.included(klass) 
        klass.class_eval do
          include Lims::Core::Actions::Action
          include After
          include Lims::LaboratoryApp::Labels::Labellable::CreateLabellableShared
          attribute :labels, Hash, :default => nil
        end
      end
      module After
        def _call_in_session(session)
          debugger
          # normaly the result should have to keys
          # the uuid one and the model one
          create(session).tap do |result|
          uuid = result[:uuid]
          _create(uuid, 'resource', labels, session) if labels
          end
        end
      end
    end
  end
end
