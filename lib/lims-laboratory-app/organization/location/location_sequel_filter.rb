require 'lims-core/persistence/sequel/filters'

module Lims::Core
  module Persistence
    module Sequel::Filters
      def location_filter(criteria)
        comparison_criteria = criteria.delete(:comparison)
        location_dataset = @session.location.dataset
        criteria[:location].each do |key, value|
          location_dataset = add_criteria(location_dataset, key, value)
        end

        # add comparison criteria if exists
        location_dataset = add_comparison_filter(location_dataset, comparison_criteria).dataset if comparison_criteria

        self.class.new(self, location_dataset)
      end

      def add_criteria(location_dataset, key, value)
        location_dataset.where(::Sequel.ilike(key.to_sym, "%#{value}%"))
      end
    end
  end
end
