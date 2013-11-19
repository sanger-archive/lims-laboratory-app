module Lims::LaboratoryApp
  module Laboratory
    module AliquotContentShared

      InvalidContent = Class.new(StandardError)

      # @param [Session] session
      # @return [Hash]
      def change_content(session, content_type)
        resources = []

        parameters.each do |swap_sample|
          resource = swap_sample["resource"]
          moves = swap_sample["swaps"] 

          # Tube rack, plate...
          if resource.is_a?(Container)
            resource.each do |aliquots|
              if aliquots
                aliquots.each do |aliquot|
                  move_content!(session, moves, aliquot, content_type) 
                end
              end
            end
          # Tube, spin column...
          else
            resource.each do |aliquot|
              move_content!(session, moves, aliquot, content_type) 
            end
          end
          resources << resource
        end

        resources 
      end

      private

      # @param [Session] session
      # @param [Hash] moves
      # @param [Lims::LaboratoryApp::Laboratory::Aliquot] aliquot
      def move_content!(session, moves, aliquot, content_type)
        moves.each do |old_content_uuid, new_content_uuid|
          old_content = session[old_content_uuid]
          new_content = session[new_content_uuid]
          raise InvalidContent, "The content (sample/snp_assay) #{old_content_uuid} cannot be found" unless old_content
          raise InvalidContent, "The content (sample/snp_assay) #{new_content_uuid} cannot be found" unless new_content
          if contents_equal?(session, aliquot.send(content_type.to_sym), old_content)
            aliquot.send("#{content_type}=".to_sym, new_content)
            break # Important, do not move again
          end                 
        end
      end

      # @param [Session] session
      # @param [Lims::LaboratoryApp::Laboratory::Sample/Assay] content1
      # @param [Lims::LaboratoryApp::Laboratory::Sample/Assay] content2
      # @return [Bool]
      # When we evaluate only content1 == content2, it basically compare
      # the name of the 2 contents (sample/snp_assay). So, if they have the same name,
      # it returns true whereas they are actually different.
      # A good improvement is to compare the uuid of them.
      def contents_equal?(session, content1, content2)
        session.uuid_for(content1) == session.uuid_for(content2)
      end

    end
  end
end
