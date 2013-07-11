# create_labellable.rb
require 'lims-core/actions/action'
require 'lims-laboratory-app/labels/labellable'
require 'lims-laboratory-app/labels/labellable/create_labellable_shared'

module Lims::LaboratoryApp
  module Labels
    class Labellable

      LabelPositionNotExistError = Class.new(Lims::Core::Actions::Action::InvalidParameters)
      InsufficientLabelInformationError = Class.new(Lims::Core::Actions::Action::InvalidParameters)

      # Updates a Label of a given Labellable resource
      class UpdateLabel
        include Lims::Core::Actions::Action

        attribute :labellable, Labels::Labellable, :required => true
        attribute :existing_position, String, :required => true
        # hash to update the label property on the above given position
        attribute :new_label, Hash, :default => {}, :required => true

        def _call_in_session(session)
          raise InsufficientLabelInformationError,
            {"general" => "Not enough information provided regarding the label to change"} unless check_update_information(new_label)

          label_to_update = labellable.delete(existing_position)

          raise LabelPositionNotExistError,
            {"position" => "There is no label exist in the '#{existing_position}' position."} unless label_to_update

          label_to_update.type = new_label["type"] if new_label.has_key?("type")
          label_to_update.value = new_label["value"] if new_label.has_key?("value")
          updated_position = new_label.has_key?("position") ? new_label["position"] : existing_position

          labellable[updated_position] = label_to_update

          {:labellable => labellable}
        end

        private

        # check, whether the client provided enough information for the update
        def check_update_information(label)
          update_provided = true
          if label["position"].nil? && label["type"].nil? && label["value"].nil?
            update_provided = false
          end
          update_provided
        end

      end
    end
  end
end
