module Lims::LaboratoryApp
  module Labels
    class Labellable
      module CreateLabellableShared
        def _create(name, type, labels, session)
          labellable = Labels::Labellable.new(:name => name, :type => type)
          session << labellable
          add_labels(labels, labellable)

          {:labellable => labellable, :uuid => session.uuid_for!(labellable)}
        end

        def add_labels(labels, labellable)
          labels.each do |position, label|
            created_label = Labels::Labellable::Label.new(:type => label["type"], :value => label["value"])
            labellable[position] = created_label
          end
        end
      end
    end
  end
end
