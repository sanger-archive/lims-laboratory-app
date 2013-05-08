require 'lims-core/persistence/sequel/filters'
require 'lims-laboratory-app/labels/labellable/all'

module Lims::Core
  module Persistence
    module Sequel::Filters
      def label_filter(criteria)
        comparison_criteria = criteria.delete(:comparison)
        labellable_dataset = @session.labellable.__multi_criteria_filter(criteria).dataset

        # join labellabe request to uuid_resource
        # If the persistor class is a Sequel::Labellable, it means
        # the searched resource is a labellable. Then the joint with
        # uuid_resources is made between uuid_resources#key and
        # labellables#id.
        uuid_resources_joint = (self.class == Lims::LaboratoryApp::Labels::Labellable::LabellableSequelPersistor) ? {:key => :"id"} : {:uuid => :"name"}
        persistor = self.class.new(self, labellable_dataset.join("uuid_resources", uuid_resources_joint).select(:key).qualify(:uuid_resources))

        # add comparison criteria if exists
        persistor = add_comparison_filter(persistor.dataset, comparison_criteria) if comparison_criteria

        # join everything to current resource table
        # Qualify method is needed to get only the fields related to the searched
        # resource. Otherwise, multiple id columns are returned which lead to a
        # ambiguous situation when we try to get the id of the resource. 
        # This leads to an incorrect uuid for the found resources.
        self.class.new(self, dataset.join(persistor.dataset, :key => primary_key).qualify)
      end
    end
  end
end
