require 'lims-core/actions/action'

module Lims::LaboratoryApp
  module Laboratory
    class Sample
     
      InvalidSample = Class.new(StandardError)

      class SwapSamples
        include Lims::Core::Actions::Action

        attribute :parameters, Array, :required => true, :writer => :private

        # @param [Session] session
        # @return [Hash]
        def _call_in_session(session)
          resources = []

          parameters.each do |swap_sample|
            resource = swap_sample["resource"]
            swaps = swap_sample["swaps"] 

            # Tube rack, plate...
            if resource.is_a?(Container)
              resource.each do |aliquots|
                if aliquots
                  aliquots.each do |aliquot|
                    swap_sample!(session, swaps, aliquot) 
                  end
                end
              end
            # Tube, spin column...
            else
              resource.each do |aliquot|
                swap_sample!(session, swaps, aliquot) 
              end
            end
            resources << resource
          end

          {:resources => resources} 
        end

        private

        # @param [Session] session
        # @param [Hash] swaps
        # @param [Lims::LaboratoryApp::Laboratory::Aliquot] aliquot
        def swap_sample!(session, swaps, aliquot)
          swaps.each do |old_sample_uuid, new_sample_uuid|
            old_sample = session[old_sample_uuid]
            new_sample = session[new_sample_uuid]
            raise invalidsample, "the sample #{old_sample_uuid} cannot be found" unless old_sample
            raise invalidsample, "the sample #{new_sample_uuid} cannot be found" unless new_sample
            if aliquot.sample == old_sample
              aliquot.sample = new_sample
              break # Important, do not swap again if we've found a swap for the current aliquot
            end                 
          end
        end
      end
    end
  end
end
