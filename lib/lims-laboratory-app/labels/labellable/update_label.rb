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

      InsufficientLabelInformationError = Class.new(StandardError) do
        def initialize
          super("Not enough information provided regarding the label to change")
        end
      end

      # Updates a Label of a given Labellable resource
      class UpdateLabel
        include Lims::Core::Actions::Action

        attribute :labellable, Labels::Labellable, :required => true
        attribute :existing_position, String, :required => true
        # hash to update the label property on the above given position
        attribute :new_label, Hash, :default => {}, :required => true

        def _call_in_session(session)
          raise InsufficientLabelInformationError unless check_update_information(new_label)

          label_to_update = labellable[existing_position]

          raise LabelPositionNotExistError.new(existing_position) unless label_to_update

          # update the type/value if position is not chnaged
          if new_label.has_key?("position") == false || new_label["position"] == existing_position
            label_to_update.type = new_label["type"] if new_label.has_key?("type")
            label_to_update.value = new_label["value"] if new_label.has_key?("value")
          else
            type_to_add = new_label.has_key?("type") ? new_label["type"] : label_to_update["type"]
            value_to_add = new_label.has_key?("value") ? new_label["value"] : label_to_update["value"]
            label_to_add = Labels::Labellable::Label.new(
              { :type => type_to_add,
                :value => value_to_add
              }
            )
            labellable.delete(existing_position)
            labellable[new_label["position"]] = label_to_add
          end

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
