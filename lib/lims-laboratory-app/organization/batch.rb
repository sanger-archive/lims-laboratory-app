# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en 
require 'common'
require 'lims-core/resource'

module Lims::LaboratoryApp
  module Organization
    # A batch groups multiple items together.
    class Batch
      include Lims::Core::Resource
      # Store the process that the batch is going through.
      # Ex: 8 tubes might go through the process "manual extraction".
      attribute :process, String, :required => false
      attribute :kit, String, :required => false
    end
  end
end
