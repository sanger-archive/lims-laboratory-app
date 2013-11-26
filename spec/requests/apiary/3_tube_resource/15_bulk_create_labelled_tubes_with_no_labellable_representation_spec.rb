require "requests/apiary/3_tube_resource/spec_helper"
describe "bulk_create_labelled_tubes_with_no_labellable_representation", :tube => true do
  include_context "use core context service"
  it "bulk_create_labelled_tubes_with_no_labellable_representation" do

    header('Content-Type', 'application/json; bulk=true')
    header('Accept', 'application/json; representation=no-labellable')

    response = post "/tubes", <<-EOD
    {
    "tubes": [
        {
            "type": "Eppendorf",
            "max_volume": 2,
            "aliquots": [
                {
                    "sample_uuid": "11111111-0000-0000-0000-111111111111",
                    "type": "NA",
                    "quantity": 5
                }
            ],
            "labels": {
                "front barcode": {
                    "value": "1234-ABC",
                    "type": "ean13-barcode"
                },
                "back barcode": {
                    "value": "1234-EDF",
                    "type": "sanger-barcode"
                }
            }
        },
        {
            "type": "Eppendorf",
            "max_volume": 10,
            "aliquots": [

            ]
        },
        {
            "type": "New type",
            "max_volume": 15,
            "aliquots": [
                {
                    "sample_uuid": "11111111-0000-0000-0000-333333333333",
                    "type": "DNA",
                    "quantity": 25
                }
            ],
            "labels": {
                "front barcode": {
                    "value": "5678-ABC",
                    "type": "ean13-barcode"
                },
                "back barcode": {
                    "value": "5678-EDF",
                    "type": "sanger-barcode"
                }
            }
        }
    ]
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "actions": {
    },
    "size": 3,
    "tubes": [
        {
            "actions": {
                "read": "http://example.org/11111111-2222-3333-4444-555555555555",
                "create": "http://example.org/11111111-2222-3333-4444-555555555555",
                "update": "http://example.org/11111111-2222-3333-4444-555555555555",
                "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
            },
            "uuid": "11111111-2222-3333-4444-555555555555",
            "type": "Eppendorf",
            "max_volume": 2,
            "aliquots": [
                {
                    "sample": {
                        "actions": {
                            "read": "http://example.org/11111111-0000-0000-0000-111111111111",
                            "create": "http://example.org/11111111-0000-0000-0000-111111111111",
                            "update": "http://example.org/11111111-0000-0000-0000-111111111111",
                            "delete": "http://example.org/11111111-0000-0000-0000-111111111111"
                        },
                        "uuid": "11111111-0000-0000-0000-111111111111",
                        "name": "Sample 1"
                    },
                    "quantity": 5,
                    "type": "NA",
                    "unit": "mole"
                }
            ]
        },
        {
            "actions": {
                "read": "http://example.org/11111111-2222-3333-4444-777777777777",
                "create": "http://example.org/11111111-2222-3333-4444-777777777777",
                "update": "http://example.org/11111111-2222-3333-4444-777777777777",
                "delete": "http://example.org/11111111-2222-3333-4444-777777777777"
            },
            "uuid": "11111111-2222-3333-4444-777777777777",
            "type": "Eppendorf",
            "max_volume": 10,
            "aliquots": [

            ]
        },
        {
            "actions": {
                "read": "http://example.org/11111111-2222-3333-4444-888888888888",
                "create": "http://example.org/11111111-2222-3333-4444-888888888888",
                "update": "http://example.org/11111111-2222-3333-4444-888888888888",
                "delete": "http://example.org/11111111-2222-3333-4444-888888888888"
            },
            "uuid": "11111111-2222-3333-4444-888888888888",
            "type": "New type",
            "max_volume": 15,
            "aliquots": [
                {
                    "sample": {
                        "actions": {
                            "read": "http://example.org/11111111-0000-0000-0000-333333333333",
                            "create": "http://example.org/11111111-0000-0000-0000-333333333333",
                            "update": "http://example.org/11111111-0000-0000-0000-333333333333",
                            "delete": "http://example.org/11111111-0000-0000-0000-333333333333"
                        },
                        "uuid": "11111111-0000-0000-0000-333333333333",
                        "name": "Sample 1"
                    },
                    "quantity": 25,
                    "type": "DNA",
                    "unit": "mole"
                }
            ]
        }
    ]
}
    EOD

  end
end
