require 'modularity'
require 'lims-laboratory-app/laboratory/create_labellable_resource_action'
require 'lims-laboratory-app/laboratory/sample/create_sample_shared'
require 'lims-laboratory-app/organization/location'

module Lims::LaboratoryApp
  module Laboratory
    module Container::CreateContainerActionTrait

      as_trait do |args|
        include CreateLabellableResourceAction
        include Sample::CreateSampleShared

        container_name = args[:container_name].to_sym
        container_class = args[:container_class]
        element_description_name = args[:element_description_name].to_sym
        extra_parameters = args[:extra_parameters] ? args[:extra_parameters] << :location : [:location]

        %w(row column).each do |w|
          # Hack Aequitas 'gt' rule crashes if attribute is not present.
          # Setting the default to 0 works ...
          attribute :"number_of_#{w}s",  Fixnum, :required => true, :default => 0, :gt => 0, :writer => :private
        end

        attribute :location, Lims::LaboratoryApp::Organization::Location, :default => nil

        define_method(:element_description) do
          self.send(element_description_name)
        end

        define_method(:container_parameters) do
          {:number_of_rows => number_of_rows, :number_of_columns => number_of_columns}.tap do |attributes|
            extra_parameters.map(&:to_sym).each do |extra|
              attributes[extra] = self.send(extra)
            end
          end
        end

        define_method(:create) do |session|
          new_container = container_class.new(container_parameters)
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
          {container_name => new_container, :uuid => session.uuid_for!(new_container)}
        end
      end
    end
  end
end
