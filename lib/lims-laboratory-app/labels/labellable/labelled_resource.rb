require 'lims-api/core_resource'

module Lims::Api
  class CoreResource
    module LabelledResource
      def labellable_to_stream(s, mime_type)
        return if defined?(Lims::Core::NO_AUTOLOAD)
        if @context.last_session
          @context.last_session.tap do |session|
            labellable = session.labellable[{:name => uuid, :type => "resource"}]
            if labellable
              s.add_key "labels"
              s.with_hash do
                resource = @context.resource_for(labellable, @context.find_model_name(labellable.class))

                resource.encoder_for([mime_type]).actions_to_stream(s)
                s.add_key "uuid"
                s.add_value resource.uuid
                resource.labels_to_stream(s, mime_type)
              end
            end
          end
        end
      end
    end

    include LabelledResource
  end
end
