require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-laboratory-app/laboratory/container/create_container_action_trait'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      class CreateFilterPaper

        does "lims/laboratory_app/laboratory/container/create_container_action", {
          :container_name => "filter_paper",
          :container_class => Laboratory::FilterPaper,
          :element_description_name => "locations_description"
        }

        # @attribute [Hash<String, Array<Hash>>] locations_description
        # @example
        #   { "A1" => [{ :sample => s1, :quantity => 2}, {:sample => s2}] }
        attribute :locations_description, Hash, :default => {}
      end

      Create = CreateFilterPaper
    end
  end
end
