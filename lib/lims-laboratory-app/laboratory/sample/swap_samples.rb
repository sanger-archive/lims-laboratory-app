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
            if samples_equal?(session, aliquot.sample, old_sample)
              aliquot.sample = new_sample
              break # Important, do not swap again if we've found a swap for the current aliquot
            end                 
          end
        end

        # @param [Session] session
        # @param [Lims::LaboratoryApp::Laboratory::Sample] sample1
        # @param [Lims::LaboratoryApp::Laboratory::Sample] sample2
        # @return [Bool]
        # When we evaluate only sample1 == sample2, it basically compare
        # the name of the 2 samples. So, if the samples have the same name,
        # it returns true whereas the samples are actually different.
        # A good improvement is to compare the uuid of the samples.
        def samples_equal?(session, sample1, sample2)
          session.uuid_for(sample1) == session.uuid_for(sample2)
        end
      end
    end
  end
end
