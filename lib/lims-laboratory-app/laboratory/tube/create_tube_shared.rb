module Lims::LaboratoryApp
  module Laboratory
    class Tube
      module CreateTubeShared
        def _create(type, max_volume, aliquots, session)
          tube = Laboratory::Tube.new(:type => type, :max_volume => max_volume)
          session << tube
          aliquots.each do |aliquot|
            tube << Laboratory::Aliquot.new(aliquot)
          end
          {:tube => tube, :uuid => session.uuid_for!(tube)}
        end
      end
    end
  end
end
