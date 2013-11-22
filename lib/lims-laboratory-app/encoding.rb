require 'lims-api/core_resource'

module Lims::Api
  module CoreResource::Encoder
    module Representation

      module Default
        def self.included(klass)
          klass.class_eval do
            alias :original_to_hash_stream :to_hash_stream
          end
        end
      end

      module Labellable
        def to_hash_stream(h)
          Default::original_to_hash_stream(h)
          object.labellable_to_stream(h, @mime_type)
        end
      end

      module NoLabellable
        def to_hash_stream(h)
          Default::original_to_hash_stream(h)
        end
      end
    end

    include Representation::Default
    include Representation::Labellable
  end
end
