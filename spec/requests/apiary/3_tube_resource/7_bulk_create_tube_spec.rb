require "requests/apiary/3_tube_resource/spec_helper"
describe "bulk_create_tube", :tube => true do
  include_context "use core context service"
  it "bulk_create_tube" do

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/bulk_create_tube", <<-EOD
    {
    "bulk_create_tube": {
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
                ]
            },
            {
                "type": "Eppendorf",
                "max_volume": 10,
                "aliquots": [
                    {
                        "sample_uuid": "11111111-0000-0000-0000-222222222222",
                        "type": "RNA",
                        "quantity": 15
                    }
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
                ]
            }
        ]
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "bulk_create_tube": {
        "actions": {
        },
        "user": "user@example.com",
        "application": "application_id",
        "result": {
            "tubes": [
                {
                    "actions": {
                        "read": "http://example.org/11111111-2222-3333-4444-555555555555",
                        "create": "http://example.org/11111111-2222-3333-4444-555555555555",
                        "update": "http://example.org/11111111-2222-3333-4444-555555555555",
                        "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
                    },
                    "uuid": "11111111-2222-3333-4444-555555555555",
                    "location": null,
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
                        "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "create": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "delete": "http://example.org/11111111-2222-3333-4444-666666666666"
                    },
                    "uuid": "11111111-2222-3333-4444-666666666666",
                    "location": null,
                    "type": "Eppendorf",
                    "max_volume": 10,
                    "aliquots": [
                        {
                            "sample": {
                                "actions": {
                                    "read": "http://example.org/11111111-0000-0000-0000-222222222222",
                                    "create": "http://example.org/11111111-0000-0000-0000-222222222222",
                                    "update": "http://example.org/11111111-0000-0000-0000-222222222222",
                                    "delete": "http://example.org/11111111-0000-0000-0000-222222222222"
                                },
                                "uuid": "11111111-0000-0000-0000-222222222222",
                                "name": "Sample 1"
                            },
                            "quantity": 15,
                            "type": "RNA",
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
                    "location": null,
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
        },
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
                ]
            },
            {
                "type": "Eppendorf",
                "max_volume": 10,
                "aliquots": [
                    {
                        "sample_uuid": "11111111-0000-0000-0000-222222222222",
                        "type": "RNA",
                        "quantity": 15
                    }
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
                ]
            }
        ]
    }
}
    EOD

  end
end
