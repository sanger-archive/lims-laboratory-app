# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-laboratory-app/labels/labellable/create_labellable_shared'
require 'lims-laboratory-app/labels/labellable/eager_load_labellable'
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
          # normaly the result should have to keys
          # the uuid one and the model one
          create(session).tap do |result|
            resource_name = (result.keys - [:uuid]).first
            persistor = session.persistor_for(resource_name)
            resource = result[resource_name]
            session.send(resource_name).extend Labels::Labellable::EagerLoadLabellable

            if labels
              uuid = result[:uuid]
              labellable_result = _create(uuid, 'resource', labels, session)
              persistor.bind_labellable(resource, labellable_result[:labellable])
            else
              persistor.bind_labellable(resource, nil)
            end
          end
        end
      end
    end
  end
end
