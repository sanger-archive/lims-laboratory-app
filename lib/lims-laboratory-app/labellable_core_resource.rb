require 'lims-api/core_resource'

module Lims::LaboratoryApp
  class LabellableCoreResource < Lims::Api::CoreResource

    def labellable_to_stream(s, mime_type)
      labellable = if object.is_a? Lims::LaboratoryApp::WithLabellable
                     object.labellable
                   elsif @context.last_session
                     @context.last_session.labellable[{:name => uuid, :type => "resource"}]
                   end

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

    module Encoder
      # TODO: when using ruby 2.0, the following code can be replaced
      # using "prepend" as it includes the module below the class in 
      # the inheritance hierarchy. We can then call super() to access
      # the core_resource to_hash_stream method.
      module Representation
        # Include the default representation from CoreResource in 
        # the LabellableResource::Encoder::Representation module.
        include Lims::Api::CoreResource::Encoder::Representation

        module AliasToHashStream
          def self.included(klass)
            klass.class_eval do
              alias :original_to_hash_stream :to_hash_stream
            end
          end
        end

        module Labellable
          def to_hash_stream(h)
            original_to_hash_stream(h)
            object.labellable_to_stream(h, @mime_type)
          end
        end

        module NoLabellable
          def to_hash_stream(h)
            original_to_hash_stream(h)
          end
        end
      end
    end

    def self.encoder_class_map
      Encoders.mash { |k| [k::ContentType, k] }
    end

    Encoders = Lims::Api::CoreResource::Encoders.map do |encoder|
      class_eval do
        class JsonEncoder < encoder
          include Encoder
          include Representation::AliasToHashStream
          include Representation::Labellable
        end
      end
    end
  end
end
