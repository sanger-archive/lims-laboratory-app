# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-core/actions/action'
require 'lims-laboratory-app/organization/batch'

module Lims::LaboratoryApp
  module Organization
    class Batch
      class UpdateBatch
        include Lims::Core::Actions::Action

        attribute :batch, Organization::Batch, :required => true, :writer => :private
        attribute :process, String, :required => false, :writer => :private
        attribute :kit, String, :required => false, :writer => :private

        def _call_in_session(session)
          batch.process = process if process
          batch.kit = kit if kit
          {:batch => batch}
        end
      end

      Update = UpdateBatch
    end
  end
end
