require 'lims-laboratory-app/laboratory/create_labellable_resource_action'
require 'lims-laboratory-app/laboratory/sample/create_sample_shared'

module Lims::LaboratoryApp
  module Laboratory
    module Container::CreateContainerAction

      def self.included(klass)
        klass.class_eval do
          include CreateLabellableResourceAction
          include Virtus
          include Aequitas
          include Sample::CreateSampleShared

          # Everything contained in out_of_bounds parameter is send through
          # s2 but not stored in s2.
          attribute :out_of_bounds, Hash, :required => false, :default => {}, :writer => :private

          %w(row column).each do |w|
            # Hack Aequitas 'gt' rule crashes if attribute is not present.
            # Setting the default to 0 works ...
            attribute :"number_of_#{w}s",  Fixnum, :required => true, :default => 0, :gt => 0, :writer => :private
          end
        end
      end

      # The specific container should implement this method
      # and return the proper container class
      # i. e. : Laboratory::Gel
      def container_class
        raise NotImplementedError
      end

      # The specific container should implement this method
      # and return the property name of specific container's element
      # i. e. : windows_description
      def element_description
        raise NotImplementedError
      end

      # The specific container should implement this method
      # and return the container name
      # i. e. : "gel"
      def container_symbol
        raise NotImplementedError
      end
 
      # Return the default parameters to create a new container 
      def container_parameters
        {:number_of_rows => number_of_rows, :number_of_columns => number_of_columns}
      end

      def create(session)
        new_container = container_class.new(container_parameters)
        new_container.out_of_bounds = out_of_bounds
        session << new_container
        count = 0
        element_description.each do |element_name, aliquots|
          aliquots.each do |aliquot|
            aliquot_ready = aliquot.mash do |k,v|
              case k.to_s
              when "sample_uuid" then 
                count += 1
                ["sample", create_sample(session, "Sample #{count}", v)] 
              else 
                [k,v]
              end
            end
            new_container[element_name] <<  Laboratory::Aliquot.new(aliquot_ready)
          end
        end
        { container_symbol => new_container, :uuid => session.uuid_for!(new_container) }
      end
    end
  end
end
