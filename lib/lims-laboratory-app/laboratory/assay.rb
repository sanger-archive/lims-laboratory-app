require 'common'
require 'lims-core/resource'
require 'lims-laboratory-app/laboratory/allele'

module Lims::LaboratoryApp
  module Laboratory
    class Assay
      include Lims::Core::Resource

      attribute :name, String, :required => true
      attribute :allele_x, Allele, :required => true
      attribute :allele_y, Allele, :required => true

    end
  end
end
