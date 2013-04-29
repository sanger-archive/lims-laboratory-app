require 'lims-core/persistence/sequel/filters'
require 'lims-laboratory-app/organization/batch/batch_filter'
require 'lims-laboratory-app/organization/order/order_sequel_filter'

module Lims::Core
  module Persistence
    module Sequel::Filters
      # Implement a batch filter for a Sequel::Persistor.
      # @param [Hash<String, Object>] criteria
      # @example
      #   {:batch => {:uuid => '11111111-2222-3333-4444-555555555555'}}
      #   Create a request to get the resources which are referenced by
      #   an order item assigned to a batch with the given uuid.
      #   Is equivalent to the criteria:
      #   {:order => {:item => {:batch => {:uuid => '11111111-2222-3333-4444-555555555555'}}}}
      def batch_filter(criteria)
        order_filter({:order => {:item => criteria } })
      end
    end
  end
end


