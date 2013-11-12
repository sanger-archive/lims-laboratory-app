require 'lims-laboratory-app/laboratory/gel'
require 'lims-laboratory-app/laboratory/container/create_container_action_trait'

module Lims::LaboratoryApp
  module Laboratory
    class Gel
      class CreateGel
        include Virtus
        include Aequitas

        # @attribute [Hash<String, Array<Hash>>] windows_description
        # @example
        #   { "A1" => [{ :sample => s1, :quantity => 2}, {:sample => s2}] }
        attribute :windows_description, Hash, :default => {}

        does "lims/laboratory_app/laboratory/container/create_container_action", {
          :container_name => "gel",
          :container_class => Laboratory::Gel,
          :element_description_name => "windows_description"
        }
      end
    end
  end

  module Laboratory
    class Gel
      Create = CreateGel
    end
  end
end
