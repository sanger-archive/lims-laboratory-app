require 'optparse'
require(File.expand_path("../barcode_map_processor", __FILE__))

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: add_kit.rb [options]"
  opts.on("-f", "--file F")     { |f| options[:file] = f }
  opts.on("-u", "--root_url U") { |u| options[:url] = u }
end.parse!

processor = Lims::LaboratoryApp::BarcodeMapProcessor.new(options)

processor.correct_barcodes
