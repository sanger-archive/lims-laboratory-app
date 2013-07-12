require 'sequel'
require 'lims-laboratory-app'
require 'optparse'

# Setup the arguments passed to the script
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: seed_test_data.rb [options]"
  opts.on("-d", "--db [DB]") { |v| options[:db] = v }
  opts.on("-v", "--verbose") { |v| options[:verbose] = true }
end.parse!

CONNECTION_STRING = options[:db]
DB = Sequel.connect(CONNECTION_STRING)
STORE = Lims::Core::Persistence::Sequel::Store.new(DB)

STORE.with_session do |session|
  tube = Lims::LaboratoryApp::Laboratory::Tube.new
  session << tube
  tube_uuid = session.uuid_for!(tube)

  labellable = Lims::LaboratoryApp::Labels::Labellable.new(:name => tube_uuid, :type => "resource")
  labellable["test"] = Lims::LaboratoryApp::Labels::Labellable::Label.new(:type => "sanger-barcode", :value => "1234-ABC")
  labellable["sanger"] = Lims::LaboratoryApp::Labels::Labellable::Label.new(:type => "sanger-barcode", :value => "ND0288261C")
  labellable["ean13"] = Lims::LaboratoryApp::Labels::Labellable::Label.new(:type => "ean13-barcode", :value => "3820288261675")
  labellable["ean13-test"] = Lims::LaboratoryApp::Labels::Labellable::Label.new(:type => "ean13-barcode", :value => "ean-test")

  session << labellable
  labellable_uuid = session.uuid_for!(labellable)
end
