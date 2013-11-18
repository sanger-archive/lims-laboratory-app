module Lims::LaboratoryApp
  module Labels
    class Labellable
      module LabelledResource
        def labellable_to_stream(s, mime_type)
          if object.labellable
            s.add_key "labels"
            s.with_hash do
              resource = @context.resource_for(object.labellable, @context.find_model_name(object.labellable.class))
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
end
