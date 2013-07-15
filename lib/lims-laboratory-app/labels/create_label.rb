# create_labellable.rb
require 'lims-core/actions/action'

require 'lims-laboratory-app/labels/labellable'

module Lims::LaboratoryApp
  module Labels
    class CreateLabel
      include Lims::Core::Actions::Action

      attribute :labellable, Lims::LaboratoryApp::Labels::Labellable, :required => true
      attribute :type, String, :required => true
      attribute :value, String, :required => true
      attribute :position, String, :required => true

      def _validate_parameters
        raise InvalidParameters, 
          "Labellable object is not exist! We can not add label to it." if labellable.nil?
      end

      def _call_in_session(session)
        label = Labels::Labellable::Label.new(:type => type,
                                      :value => value)

        labellable[position] = label

        session << labellable

        {:labellable => labellable}
      end

    end
  end

  module Labels
    class Labellable
      Update = CreateLabel
    end
  end
end
