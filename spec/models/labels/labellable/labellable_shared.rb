# Spec requirements
require 'models/spec_helper'

# Model requirements

require 'lims-laboratory-app/labels/labellable/all'
require 'facets/array'

module Lims::LaboratoryApp
  module Labels
    shared_context "labellable factory" do
      def new_labellable_with_labels(name='00000000-1111-2222-3333-444444444444', type='resource', position='front barcode', value='12345ABC')
        content = { position => Labels::SangerBarcode.new({:value => value}) }
        parameters = { :name => name, :type => type, :content => content }
        labellable = Labels::Labellable.new(parameters)
      end
    end
  end
end
