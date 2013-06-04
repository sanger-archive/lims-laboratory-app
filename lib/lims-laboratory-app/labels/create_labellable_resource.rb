# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-laboratory-app/labels/labellable/create_labellable_shared'
module Lims::LaboratoryApp
  module Labels
    module CreateLabellableResource
      def self.included(klass) 
        klass.class_eval do
          include Labellable::CreateLabellableShared
          attribute :labels, Hash, :default => nil
        end
      end

      def _call_in_session(session)
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
