module Lims::LaboratoryApp
  module Labels
    class BulkUpdateLabel
      include Lims::Core::Actions::Action

      attribute :by, String, :required => true
      attribute :labels, Hash, :default => {}, :required => true

      SangerIdNotFound        = Class.new(StandardError)
      LabellableUuidNotFound  = Class.new(StandardError)

      def _call_in_session(session)
        updated_labellables = []
        if by.downcase == "uuid"
          updated_labellables = update_labellables_by_uuid(session)
        else
          updated_labellables = update_labellables_by_position(session)
        end

        {:labellables => updated_labellables }
      end

      private

      def update_labellables_by_position(session)
        labellables = []
        labels.each do |existing_label_value, new_labels|
          labellable = session.labellable.label.dataset.filter(
            { :position => by,
              :value => existing_label_value}).first
          raise SangerIdNotFound, "Sanger id '#{existing_label_value}' is invalid" unless labellable

          labellables << add_new_labels(session, labellable[:labellable_id], new_labels)
        end

        labellables
      end

      def update_labellables_by_uuid(session)
        labellables = []

        labels.each do |labellable_uuid, new_labels|
          labellable = session.labellable.dataset.filter(:name => session.pack_uuid(labellable_uuid)).first
          raise LabellableUuidNotFound, "Labellable uuid '#{labellable_uuid}' is invalid" unless labellable

          labellables << add_new_labels(session, labellable[:id], new_labels)
        end

        labellables
      end

      def add_new_labels(session, labellable_id, new_labels)
        labellable_object = session.labellable[labellable_id]

        new_labels.each do |position, value|
          new_label = Labels::Labellable::Label.new(:type   => value["type"],
                                                    :value  => value["value"])
          labellable_object[position] = new_label
        end

        labellable_object
      end
    end
  end
end
