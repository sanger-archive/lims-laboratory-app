require 'lims-core/actions/action'

module Lims::LaboratoryApp
  module Laboratory
    module Container::UpdateContainerAction

      def self.included(klass)
        klass.class_eval do
          include Lims::Core::Actions::Action
          include Virtus
          include Aequitas

          # aliquot_type and aliquot_quantity will replace the type and
          # the quantity of every single aliquot contained in the resource.
          attribute :aliquot_type, String, :required => false, :writer => :private
          attribute :aliquot_quantity, Numeric, :required => false, :writer => :private

          # out_of_bounds parameter is not stored in s2 database, just passed
          # through s2 to the message bus.
          attribute :out_of_bounds, Hash, :required => false, :writer => :private
        end
      end

      def container_symbol
        raise NotImplementedError 
      end

      def container
        self.send(container_symbol)
      end

      def elements_symbol
        raise NotImplementedError
      end

      def elements
        self.send(elements_symbol)
      end

      # @param [Session] session
      # @return [Hash]
      def update(session)
        container.out_of_bounds = out_of_bounds if out_of_bounds

        elements.each do |location, element_data|
          sample = element_data["sample"]
          aliquot_type = element_data["aliquot_type"]
          aliquot_quantity = element_data["aliquot_quantity"]
          aliquot_out_of_bounds = element_data["out_of_bounds"]
          aliquot = container[location.to_s].content.find { |aliquot| aliquot.sample == sample }

          if aliquot
            aliquot.type = aliquot_type if aliquot_type
            aliquot.quantity = aliquot_quantity if aliquot_quantity
            aliquot.out_of_bounds = aliquot_out_of_bounds if aliquot_out_of_bounds
          end
        end

        container.each do |element|
          element.each do |aliquot|
            aliquot.type = aliquot_type if aliquot_type
            aliquot.quantity = aliquot_quantity if aliquot_quantity
          end
        end

        {container_symbol => container}
      end
    end
  end
end
