require 'modularity'
require 'lims-laboratory-app/organization/location'

module Lims::LaboratoryApp
  module Laboratory
    module Container::UpdateContainerActionTrait

      as_trait do |args|
        container_name = args[:container_name].to_sym
        elements_name = args[:elements_name].to_sym

        # aliquot_type and aliquot_quantity will replace the type and
        # the quantity of every single aliquot contained in the resource.
        attribute :aliquot_type, String, :required => false, :writer => :private
        attribute :aliquot_quantity, Numeric, :required => false, :writer => :private
        # Change the shipping location of the tube
        attribute :location, Lims::LaboratoryApp::Organization::Location, :required => false

        define_method(:container) do
          self.send(container_name)
        end

        define_method(:elements) do
          self.send(elements_name)
        end

        # @param [Session] session
        # @return [Hash]
        define_method(:update) do |session|
          # Update aliquot individually 
          elements.each do |position, element_data|
            sample = element_data["sample"]
            aliquot_type = element_data["aliquot_type"]
            aliquot_quantity = element_data["aliquot_quantity"]
            aliquot_out_of_bounds = element_data["out_of_bounds"]
            aliquot = container[position.to_s].content.find { |aliquot| aliquot.sample == sample }

            if aliquot
              aliquot.type = aliquot_type if aliquot_type
              aliquot.quantity = aliquot_quantity if aliquot_quantity
              aliquot.out_of_bounds = aliquot_out_of_bounds if aliquot_out_of_bounds
            end
          end

          # Update aliquot globally
          container.each do |element|
            element.each do |aliquot|
              aliquot.type = aliquot_type if aliquot_type
              aliquot.quantity = aliquot_quantity if aliquot_quantity
            end
          end

          # Update container shipping location
          container.location = location if location

          {container_name => container}
        end

        def _call_in_session(session)
          update(session)
        end
      end
    end
  end
end
