require 'lims-core/actions/action'

module Lims::LaboratoryApp
  module Laboratory
    class Sample
      class SwapSamples
        include Lims::Core::Actions::Action

        attribute :swap_samples, Array, :required => true, :writer => :private

        def _call_in_session(session)
          resources = []

          swap_samples.each do |swap_sample|
            resource = swap_sample["resource"]
            swaps = swap_sample["swaps"] 

            swaps.each do |old_sample_uuid, new_sample_uuid|
              old_sample = session[old_sample_uuid]
              new_sample = session[new_sample_uuid]

              # For plates, tube_racks...
              if resource.is_a?(Container)
                resource.each do |aliquots|
                  if aliquots
                    aliquots.each do |aliquot|
                      if aliquot.sample == old_sample
                        aliquot.sample = new_sample
                      end
                    end
                  end
                end
              # For tubes, spin columns...
              else
                resource.each do |aliquot|
                  if aliquot.sample == old_sample
                    aliquot.sample = new_sample
                  end
                end
              end

              resources << resource
            end
          end

          {:resources => resources} 
        end
      end
    end
  end
end
