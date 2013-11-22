require "requests/apiary/3_tube_resource/spec_helper"
describe "create_an_new_empty_tube_and_label", :tube => true do
  include_context "use core context service"
  it "create_an_new_empty_tube_and_label" do
  # **Create an new empty tube.**

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/tubes", <<-EOD
    {
    "tube": {
        "labels": {
            "front barcode": {
                "value": "1234-ABC",
                "type": "ean13-barcode"
            },
            "back barcode": {
                "value": "1234-ABC",
                "type": "sanger-barcode"
            }
        }
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "tube": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "type": null,
        "max_volume": null,
        "aliquots": [

        ],
        "labels": {
            "actions": {
                "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                "create": "http://example.org/11111111-2222-3333-4444-666666666666",
                "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                "delete": "http://example.org/11111111-2222-3333-4444-666666666666"
            },
            "uuid": "11111111-2222-3333-4444-666666666666",
            "front barcode": {
                "value": "1234-ABC",
                "type": "ean13-barcode"
            },
            "back barcode": {
                "value": "1234-ABC",
                "type": "sanger-barcode"
            }
        }
    }
}
    EOD

  end
end
