require 'lims-api/core_resource'

module Lims::Api
  class CoreResource
    module Encoder

      # TODO: when using ruby 2.0, the following code can be replaced
      # using "prepend" as it includes the module below the class in 
      # the inheritance hierarchy. We can then call super() to access
      # the core_resource to_hash_stream method.
      module Representation
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

    Encoders.find { |e| e == JsonEncoder }.tap do |json_encoder|
      json_encoder.class_eval do
        include Encoder::Representation::AliasToHashStream
        include Encoder::Representation::Labellable
      end
    end
  end
end
