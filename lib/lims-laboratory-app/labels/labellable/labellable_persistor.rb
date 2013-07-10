require 'lims-core/persistence/persistor'
require 'lims-laboratory-app/labels/labellable'

# needs to require all label subclasses
require 'lims-laboratory-app/labels/sanger_barcode'

module Lims::LaboratoryApp
  module Labels
    class Labellable
      class LabellablePersistor < Lims::Core::Persistence::Persistor
        Model = Labels::Labellable

        def label
          @session.labellable_label
        end

        # Saves all children of a given Labellable
        def save_children(id, labellable)
          labellable.each do |position, label_object|
            label.save(label_object, id, position)
          end
        end

        # deletes all children of a given Labellable
        def delete_children(id, object)
          label.dataset.filter(:labellable_id => id).delete
        end
        protected :delete_children

        # Loads all children of a given Labellable
        def load_children(id, labellable)
          label.load(id) do |position, label|
            labellable[position]=label
          end
        end
      end
      module Label 
        SESSION_NAME=:labellable_label
        class LabelPersistor < Lims::Core::Persistence::Persistor
          Model = Labels::Labellable::Label
        end
      end
    end
  end
end
