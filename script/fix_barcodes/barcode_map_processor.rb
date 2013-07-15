require 'uri'
require 'rest_client'
require 'json'

module Lims::LaboratoryApp
  class BarcodeMapProcessor

    attr_reader :file_name
    attr_reader :root_url

    API_HEADERS = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
    CORRECT_BARCODES = "/actions/correct_barcodes"

    def initialize(options)
      @options = options
      @file_name  = @options[:file]
      @root_url   = @options[:url] || "http://localhost:9292/"
    end

    # calls the CorrectBarcodes action to fix the labels in the DB and the warehouse
    def correct_barcodes
      parameters = {
        "correct_barcodes" => {
          "file_name"   => @file_name
        }
      }
      
      RestClient.post(URI.join(@root_url, CORRECT_BARCODES).to_s, parameters.to_json, API_HEADERS)
    end
  end
end
