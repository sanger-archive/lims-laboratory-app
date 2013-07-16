require 'lims-core'
require 'logger'
require 'lims-core/persistence/sequel'
require(File.expand_path("../barcode_map_processor", __FILE__))
require(File.expand_path("../seed_test_data", __FILE__))
require 'lims-laboratory-app'

Loggers = []
#Loggers << Logger.new($stdout)

def connect_db(env)
  config = YAML.load_file(File.join('config','database.yml'))
  Sequel.connect(config[env.to_s], :loggers => Loggers)
end

module Lims::LaboratoryApp

  shared_context 'use core context service' do
    let(:db) { connect_db(:development) }
    let(:store) { Lims::Core::Persistence::Sequel::Store.new(db) }
    let(:message_bus) { mock(:message_bus).tap { |m| m.stub(:publish) } } 
    let(:context_service) { Lims::Api::ContextService.new(store, message_bus) }

    #This code is cleaning up the DB after each test case execution
    after(:each) do
      # list of all the tables in our DB
      %w{items orders batches searches labels labellables tube_aliquots spin_column_aliquots windows wells lanes tag_group_associations aliquots tube_rack_slots tube_racks tubes spin_columns gels plates flowcells samples oligos tag_groups studies users uuid_resources}.each do |table|
        db[table.to_sym].delete
      end
      db.disconnect
    end
  end

  describe BarcodeMapProcessor do
    include_context "use core context service"

    before(:each) do
      SeedTestData::create_test_data(db)
    end

    context do
      let(:options) {
        { :db   => "sqlite:///Users/ke4/projects/lims-laboratory-app/dev.db",
          :file => "/Users/ke4/mapping.txt",
          :url  => "http://localhost:9292/"
        }
      }
      let(:described_class) { BarcodeMapProcessor.new(options) }

      it {
        result = described_class.correct_barcodes
        JSON.parse(result).should be_a Hash
      }

      it {
        expect do
          result = described_class.correct_barcodes
        end.to change { db[:labels].count}.by(2)
      }

      it {
        described_class.correct_barcodes
        ean13_labels = db[:labels].select(:value).where(
          :type     => "ean13-barcode",
          :position => "ean13").all
        ean13_labels.each do |label|
          label[:value].should == "3820288261682"
        end

        sanger_labels = db[:labels].select(:value).where(
          :type     => "sanger-barcode",
          :position => "sanger").all
        sanger_labels.each do |label|
          label[:value].should == "ND0288261D"
        end
      }
    end
  end
end
