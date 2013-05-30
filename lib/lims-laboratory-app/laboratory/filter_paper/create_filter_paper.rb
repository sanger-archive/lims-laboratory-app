require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-laboratory-app/laboratory/container/action_container'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      class CreateFilterPaper
        include Lims::Core::Actions::Action
        # The ActionContainer module implements the _call_in_session method.
        # This method create an instance of the actual resource of all
        # the container like object (like FilterPaper, Plate, Gel)
        include Container::ActionContainer

        # @attribute [Hash<String, Array<Hash>>] locations_description
        # @example
        #   { "A1" => [{ :sample => s1, :quantity => 2}, {:sample => s2}] }
        attribute :locations_description, Hash, :default => {}

        # The ActionContainer using this method.
        # It should return the object of the class to create.
        def container_class
          Laboratory::FilterPaper
        end

        # The ActionContainer using this method.
        # It should return the property name of specific container's element.
        def element_description
          locations_description
        end

        # The ActionContainer using this method.
        # It should return the name of the container in symbol type.
        def container_symbol
          :filter_paper
        end
      end

      Create = CreateFilterPaper
    end
  end
end
