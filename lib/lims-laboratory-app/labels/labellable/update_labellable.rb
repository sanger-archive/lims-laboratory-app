# create_labellable.rb
require 'lims-core/actions/action'
require 'lims-laboratory-app/labels/labellable'
require 'lims-laboratory-app/labels/labellable/create_labellable_shared'

module Lims::LaboratoryApp
  module Labels
    class Labellable

      LabelPositionNotExistError = Class.new(StandardError) do
        def initialize(position)
          super("There is no label exist in the '#{position}' position.")
        end
      end

      LabelNotExistError = Class.new(StandardError) do
        def initialize(position, value, type)
          super("There is no label exist in the '#{position}' position with this parameters: value: '#{value}', type: '#{type}'.")
        end
      end

      InsufficientLabelInformationError = Class.new(StandardError) do
        def initialize
          super("Not enough information provided regarding the label to change")
        end
      end

      # Updates a Labellable resource and its related Label resorce(s)
      class UpdateLabellable
        include Lims::Core::Actions::Action
        include Lims::LaboratoryApp::Labels::Labellable::CreateLabellableShared

        attribute :labellable, Labels::Labellable, :required => true
        attribute :name, String, :required => false
        attribute :type, String, :required => false
        # labels array to update their values
        attribute :labels_to_update, Array, :default => [], :required => false

        def _call_in_session(session)
          labellable.name = name if name
          labellable.type = type if type
          labels_to_update.each do |new_label|
            raise InsufficientLabelInformationError unless check_update_information(new_label)

            value_for_update = new_label["new_value"]
            existing_label = labellable[new_label["position"]]

            existing_label.value = value_for_update if label_exist(new_label, existing_label)
          end

          {:labellable => labellable}
        end

        private

        # checks label (to update) existence
        def label_exist(new_label, existing_label)
          raise LabelPositionNotExistError.new(new_label["position"]) unless existing_label
          raise LabelNotExistError.new(new_label["position"], new_label["existing_value"], new_label["type"]) unless
            existing_label.value  == new_label["existing_value"] &&
            existing_label.type   == new_label["type"]
          true
        end

        # check, whether the client provided enough information for the update
        def check_update_information(label)
          update_provided = true
          if label["position"].nil? ||
            label["type"].nil? ||
            label["existing_value"].nil? ||
            label["new_value"].nil?
            update_provided = false
          end
          update_provided
        end

      end
    end
  end
end
