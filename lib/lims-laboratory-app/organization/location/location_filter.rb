require 'lims-core/persistence/filter'
require 'lims-core/resource'

module Lims::Core
  module Persistence
    class LocationFilter < Filter 
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
        persistor.location_filter(criteria)
      end
    end

    class Persistor
      # @param [Hash] criteria a 
      # @return [Persistor] 
      def location_filter(criteria)
        raise NotImplementedError "location_filter methods needs to be implemented for subclass of Persistor"
      end
    end
  end
end

