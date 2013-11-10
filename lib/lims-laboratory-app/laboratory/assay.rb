require 'common'
require 'lims-core/resource'
require 'lims-laboratory-app/laboratory/allele'

module Lims::LaboratoryApp
  module Laboratory
    # An Assay is a laboratory resource, which is an investigative (analytic)
    # procedure in laboratory medicine, pharmacology, environmental biology,
    # and molecular biology for qualitatively assessing or quantitatively
    # measuring the presence or amount or the functional activity
    # of a target entity (sample).
    # An Assay can be put to well on a plate.
    # An Assay must have:
    # - a name (String)
    # - an allele_x (A, C, G or T)
    # - an allele_y (A, C, G or T)
    class Assay
      include Lims::Core::Resource

      attribute :name, String, :required => true
      attribute :allele_x, String, :required => true
      attribute :allele_y, String, :required => true

    end
  end
end
