module Lims::LaboratoryApp
  module Labels
    class BulkUpdateLabel
      include Lims::Core::Actions::Action

      BY_ATTRIBUTE_VALUES = ["sanger_id"]

      attribute :by, String, :required => false
      attribute :labels, Hash, :default => {}, :required => true
      validates_with_method :ensure_by_value

      SangerIdNotFound = Class.new(StandardError)

      def _call_in_session(session)
        updated_labellables = update_labellables(session)
        {:labellables => updated_labellables }
      end

      private

      # If by parameter is not nil, we check its value, otherwise returns true
      # @return [Bool]
      def ensure_by_value
        if by && !BY_ATTRIBUTE_VALUES.include?(by.downcase)
          [false, "By parameter's value '#{by}' is not valid"]
        else
          [true]
        end
      end

      def update_labellables(session)
        labellables = []
        labels.each do |existing_label_value, new_labels|
          labellable = session.labellable.label.dataset.filter(
            { :position => "sanger_id",
              :value => existing_label_value}).first
          raise SangerIdNotFound, "Sanger id '#{existing_label_value}' is invalid" unless labellable
          labellable_id = labellable[:labellable_id]

          labellable_object = session.labellable[labellable_id]
          new_labels.each do |position, value|
            new_label = Labels::Labellable::Label.new(:type   => value["type"],
                                                      :value  => value["value"])
            labellable_object[position] = new_label
          end
          labellables << labellable_object
        end

        labellables
      end
    end
  end
end
