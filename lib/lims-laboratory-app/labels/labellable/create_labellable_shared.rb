module Lims::LaboratoryApp
  module Labels
    class Labellable
      module CreateLabellableShared
        def _create(name, type, labels, session)
          labellable = Labels::Labellable.new(:name => name, :type => type)
          session << labellable
          labels.each do |position, label|
            created_label = Labels::Labellable::Label.new(:type => label["type"], :value => label["value"])
            labellable[position] = created_label
          end

          {:labellable => labellable, :uuid => session.uuid_for!(labellable)}
        end
      end
    end
  end
end
