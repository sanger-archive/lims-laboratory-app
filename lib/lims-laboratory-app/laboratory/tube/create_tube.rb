# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-laboratory-app/laboratory/tube'
require 'lims-laboratory-app/laboratory/create_labellable_resource_action'
require 'lims-laboratory-app/laboratory/sample/create_sample_shared'

module Lims::LaboratoryApp
  module Laboratory
    class Tube
      class CreateTube
        include CreateLabellableResourceAction
        include CreateSampleShared

        attribute :aliquots, Array, :default => []
        attribute :type, String, :required => false
        attribute :max_volume, Numeric, :required => false

        def initialize(*args, &block)
          @name = "Create Tube"
          super(*args, &block)
        end

        def create(session)
          tube = Laboratory::Tube.new(:type => type, :max_volume => max_volume)
          session << tube
          count = 1
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
              tube << Laboratory::Aliquot.new(aliquot_ready)
            end
          end
          {:tube => tube, :uuid => session.uuid_for!(tube)}
        end
      end
    end
  end
  module Laboratory
    class Tube
      Create = CreateTube
    end
  end
end
