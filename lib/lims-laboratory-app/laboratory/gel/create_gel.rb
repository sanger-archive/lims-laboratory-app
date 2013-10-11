require 'lims-laboratory-app/laboratory/gel'
require 'lims-laboratory-app/laboratory/container/create_container_action'

module Lims::LaboratoryApp
  module Laboratory
    class Gel
      class CreateGel
        include Container::CreateContainerAction

        # @attribute [Hash<String, Array<Hash>>] windows_description
        # @example
        #   { "A1" => [{ :sample => s1, :quantity => 2}, {:sample => s2}] }
        attribute :windows_description, Hash, :default => {}

        def container_class
          Laboratory::Gel
        end

        def element_description
          windows_description
        end

        def container_symbol
          :gel
        end
      end
    end
  end

  module Laboratory
    class Gel
      Create = CreateGel
    end
  end
end
