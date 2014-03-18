require 'modularity'
require 'lims-laboratory-app/laboratory/receptacle'
require 'lims-laboratory-app/laboratory/sample/create_sample_shared'
require 'lims-laboratory-app/laboratory/create_labellable_resource_action'
require 'lims-laboratory-app/organization/location/all'

module Lims::LaboratoryApp
  module Laboratory::Receptacle
    module CreateReceptacleActionTrait

      as_trait do |args|
        include Laboratory::CreateLabellableResourceAction
        include Laboratory::Sample::CreateSampleShared

        attribute :aliquots, Array, :default => []
        attribute :location, Organization::Location, :default => nil

        receptacle_name = args[:receptacle_name].to_sym
        receptacle_class = args[:receptacle_class]
        extra_parameters = args[:extra_parameters] ? args[:extra_parameters] << :location : [:location]

        define_method(:receptacle_parameters) do
          {}.tap do |p|
            extra_parameters.map(&:to_sym).each do |extra|
              p[extra] = self.send(extra)
            end
          end
        end

        define_method(:create) do |session|
          new_receptacle = receptacle_class.new(receptacle_parameters)
          session << new_receptacle
          count = 0
          if aliquots
            aliquots.each do |aliquot|
              # The sample uuid comes from lims-management-app, 
              # as a result, the sample is not present in the 
              # lims-laboratory-app sample table. The following 
              # creates a new sample with the expected uuid.
              aliquot_ready = aliquot.mash do |k,v|
                case k.to_s
                when "sample_uuid" then 
                  count += 1
                  ["sample", create_sample(session, "Sample #{count}", v)] 
                else 
                  [k,v]
                end
              end
              new_receptacle << Laboratory::Aliquot.new(aliquot_ready)
            end
          end
          {receptacle_name => new_receptacle, :uuid => session.uuid_for!(new_receptacle)}
        end
      end
    end
  end
end
