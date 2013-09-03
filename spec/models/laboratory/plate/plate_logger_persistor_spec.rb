# Spec requirements
require 'models/persistence/logger/spec_helper'
require 'models/laboratory/plate_and_gel_shared'

# Model requirements
require 'lims-core/persistence/logger/store'

module Lims::Core::Persistence
  describe Logger::Store, :store => true, :logger => true, :persistence => true do
    include_context "plate or gel factory"
    context "initialized with a logger" do
      let(:number_of_rows) { 1 }
      let(:number_of_columns) { 2 }
      let (:logger) { ::Logger.new($stdout) }
      let(:plate) { new_plate_with_samples(2) }
      subject { described_class.new(logger) }
      it "should log plate to stdout" do
        logger.should_receive(:send).with(:info, 'Lims::LaboratoryApp::Laboratory::Plate: {:type=>nil, :number_of_rows=>1, :number_of_columns=>2}')
        logger.should_receive(:send).with(:info, '- [0] - Lims::LaboratoryApp::Laboratory::Aliquot: {:sample=>"Sample A1/1", :tag=>nil, :quantity=>nil, :type=>nil, :out_of_bounds=>{}}')
        logger.should_receive(:send).with(:info, '- [0] - Lims::LaboratoryApp::Laboratory::Aliquot: {:sample=>"Sample A1/2", :tag=>nil, :quantity=>nil, :type=>nil, :out_of_bounds=>{}}')
        logger.should_receive(:send).with(:info, '- [1] - Lims::LaboratoryApp::Laboratory::Aliquot: {:sample=>"Sample A2/1", :tag=>nil, :quantity=>nil, :type=>nil, :out_of_bounds=>{}}')
        logger.should_receive(:send).with(:info, '- [1] - Lims::LaboratoryApp::Laboratory::Aliquot: {:sample=>"Sample A2/2", :tag=>nil, :quantity=>nil, :type=>nil, :out_of_bounds=>{}}')
        subject.with_session do |session|
          session << plate
        end
      end
    end
  end
end
