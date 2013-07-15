require 'optparse'
require 'fix_barcodes/barcode_map_processor'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: add_kit.rb [options]"
  opts.on("-v", "--verbose")    { |v| options[:verbose] = true }
  opts.on("-f", "--file F")     { |f| options[:file] = f }
  opts.on("-u", "--root_url U") { |u| options[:url] = u }
  opts.on("-t", "--test")       { |t| options[:test] = true }
end.parse!

processor = Lims::LaboratoryApp::BarcodeMapProcessor.new(options)

processor.correct_barcodes
