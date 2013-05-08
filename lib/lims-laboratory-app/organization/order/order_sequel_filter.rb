require 'lims-core/persistence/sequel/filters'

module Lims::Core
  module Persistence
    module Sequel::Filters
      def order_filter(criteria)
        comparison_criteria = criteria.delete(:comparison)
        criteria = criteria[:order] if criteria.keys.first.to_s == "order"
        order_persistor = @session.order.__multi_criteria_filter(criteria)
        order_dataset = order_persistor.dataset

        # If criteria doesn't include an item key, we need 
        # to make the join with the table items here.
        unless criteria.has_key?("item") or criteria.has_key?(:item)
          order_dataset = order_dataset.join(:items, :order_id => order_persistor.primary_key)
        end
        
        # Join order dataset with the uuid_resources table 
        order_dataset = order_dataset.join(:uuid_resources, :uuid => :items__uuid).select(:key).qualify(:uuid_resources) 

        # add comparison criteria if exists
        order_dataset = add_comparison_filter(order_dataset, comparison_criteria).dataset if comparison_criteria

        # Join order dataset with the resource dataset
        # Qualify method is needed to get only the fields related
        # to the resource table. Otherwise, id could be confused.
        # The expected request would be for example something like
        # select plates.* from ...
        # As a same resource could belong to multiple orders, distinct
        # is used to get only one copy of each resource.
        self.class.new(self, dataset.join(order_dataset, :key => primary_key).qualify.distinct)
      end
    end
  end
end
