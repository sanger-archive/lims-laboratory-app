require 'lims-laboratory-app/laboratory/sample/create_sample_shared'

module Lims::LaboratoryApp
  module Laboratory
    class Tube
      module CreateTubeShared

        def self.included(klass)
          klass.class_eval do
            include Sample::CreateSampleShared
          end
        end

        def createTube(type, max_volume, aliquots, session)
          tube = Laboratory::Tube.new(:type => type, :max_volume => max_volume)
          session << tube
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
              tube << Laboratory::Aliquot.new(aliquot_ready)
            end
          end
          {:tube => tube, :uuid => session.uuid_for!(tube)}
        end
      end
    end
  end
end
