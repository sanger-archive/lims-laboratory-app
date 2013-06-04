require "requests/apiary/3_tube_resource/spec_helper"
describe "bulk_create_tube_with_labels", :tube => true do
  include_context "use core context service"
  it "bulk_create_tube_with_labels" do

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

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
                ],
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
    response.status.should == 200
    response.body.should match_json <<-EOD
    {
    "bulk_create_tube": {
        "actions": {
        },
        "user": "user",
        "application": "application",
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
                                "name": null
                            },
                            "quantity": 5,
                            "type": "NA",
                            "unit": "mole"
                        }
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
                        {
                            "sample": {
                                "actions": {
                                    "read": "http://example.org/11111111-0000-0000-0000-222222222222",
                                    "create": "http://example.org/11111111-0000-0000-0000-222222222222",
                                    "update": "http://example.org/11111111-0000-0000-0000-222222222222",
                                    "delete": "http://example.org/11111111-0000-0000-0000-222222222222"
                                },
                                "uuid": "11111111-0000-0000-0000-222222222222",
                                "name": null
                            },
                            "quantity": 15,
                            "type": "RNA",
                            "unit": "mole"
                        }
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
                                "name": null
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
                ],
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
