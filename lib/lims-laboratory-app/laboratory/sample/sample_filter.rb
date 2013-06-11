# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en
require 'lims-core/persistence/filter'
require 'lims-core/resource'

module Lims::Core
  module Persistence
    class SampleFilter < Lims::Core::Persistence::Filter 
      include Lims::Core::Resource

      attribute :criteria, Hash, :required => true

      # For Sequel, keys needs to be a Symbol to be seen as column.
      # String are seen as 'value'
      def initialize(criteria)
        criteria = { :criteria => criteria } unless criteria.include?(:criteria)
        criteria[:criteria].rekey!{ |k| k.to_sym }
        super(criteria)
      end

      def call(persistor)
        persistor.sample_filter(criteria)
      end
    end

    class Persistor
      # @param [Hash] criteria a 
      # @return [Persistor] 
      def sample_filter(criteria)
        raise NotImplementedError "sample_filter methods needs to be implemented for subclass of Persistor"
      end
    end
  end
end
