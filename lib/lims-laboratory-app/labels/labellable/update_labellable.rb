# create_labellable.rb
require 'lims-core/actions/action'
require 'lims-laboratory-app/labels/labellable'
require 'lims-laboratory-app/labels/labellable/create_labellable_shared'

module Lims::LaboratoryApp
  module Labels
    class Labellable
      # Updates a Labellable resource and its related Label resorce(s)
      class UpdateLabellable
        include Lims::Core::Actions::Action
        include Lims::LaboratoryApp::Labels::Labellable::CreateLabellableShared

        attribute :labellable, Labels::Labellable, :required => true, :writer => :private
        attribute :name, String, :required => false, :writer => :private, :initializable => true
        attribute :type, String, :required => false, :writer => :private, :initializable => true
        # labels array to update their values
        attribute :labels_to_update, Array, :default => [], :required => false, :writer => :private, :initializable => true
        # labels hash to add new labels to a labellable
        attribute :new_labels, Hash, :default => {}, :required => false, :writer => :private, :initializable => true

        def _call_in_session(session)
          labellable.name = name if name
          labellable.type = type if type
          labels_to_update.each do |change_item|
            original_label_item = change_item["original_label"]
            value_for_update = change_item["value_for_update"]
            original_label = labellable[original_label_item["position"]]
            if original_label
              original_label.value = value_for_update
            end
          end

          add_labels(new_labels, labellable)

          {:labellable => labellable}
        end
      end
    end
  end
  module Labels
    class Labellable
      Update = UpdateLabellable
    end
  end
end
