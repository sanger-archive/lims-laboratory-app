require "requests/apiary/3_tube_resource/spec_helper"
describe "bulk_create_tube", :tube => true do
  include_context "use core context service"
  it "bulk_create_tube" do
    save_with_uuid({
      Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1') => [1,2,3,4,6],
    Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 2') => [1,2,3,4,7],
    Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 3') => [1,2,3,4,8]})

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
                        "sample_uuid": "11111111-2222-3333-4444-666666666666",
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
                        "sample_uuid": "11111111-2222-3333-4444-777777777777",
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
                        "sample_uuid": "11111111-2222-3333-4444-888888888888",
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
                                    "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                                    "create": "http://example.org/11111111-2222-3333-4444-666666666666",
                                    "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                                    "delete": "http://example.org/11111111-2222-3333-4444-666666666666"
                                },
                                "uuid": "11111111-2222-3333-4444-666666666666",
                                "name": "sample 1"
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
                    "type": "Eppendorf",
                    "max_volume": 10,
                    "aliquots": [
                        {
                            "sample": {
                                "actions": {
                                    "read": "http://example.org/11111111-2222-3333-4444-777777777777",
                                    "create": "http://example.org/11111111-2222-3333-4444-777777777777",
                                    "update": "http://example.org/11111111-2222-3333-4444-777777777777",
                                    "delete": "http://example.org/11111111-2222-3333-4444-777777777777"
                                },
                                "uuid": "11111111-2222-3333-4444-777777777777",
                                "name": "sample 2"
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
                    "type": "New type",
                    "max_volume": 15,
                    "aliquots": [
                        {
                            "sample": {
                                "actions": {
                                    "read": "http://example.org/11111111-2222-3333-4444-888888888888",
                                    "create": "http://example.org/11111111-2222-3333-4444-888888888888",
                                    "update": "http://example.org/11111111-2222-3333-4444-888888888888",
                                    "delete": "http://example.org/11111111-2222-3333-4444-888888888888"
                                },
                                "uuid": "11111111-2222-3333-4444-888888888888",
                                "name": "sample 3"
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
                        "sample": {
                            "sample": {
                                "actions": {
                                    "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                                    "create": "http://example.org/11111111-2222-3333-4444-666666666666",
                                    "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                                    "delete": "http://example.org/11111111-2222-3333-4444-666666666666"
                                },
                                "uuid": "11111111-2222-3333-4444-666666666666",
                                "name": "sample 1"
                            }
                        },
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
                        "sample": {
                            "sample": {
                                "actions": {
                                    "read": "http://example.org/11111111-2222-3333-4444-777777777777",
                                    "create": "http://example.org/11111111-2222-3333-4444-777777777777",
                                    "update": "http://example.org/11111111-2222-3333-4444-777777777777",
                                    "delete": "http://example.org/11111111-2222-3333-4444-777777777777"
                                },
                                "uuid": "11111111-2222-3333-4444-777777777777",
                                "name": "sample 2"
                            }
                        },
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
                        "sample": {
                            "sample": {
                                "actions": {
                                    "read": "http://example.org/11111111-2222-3333-4444-888888888888",
                                    "create": "http://example.org/11111111-2222-3333-4444-888888888888",
                                    "update": "http://example.org/11111111-2222-3333-4444-888888888888",
                                    "delete": "http://example.org/11111111-2222-3333-4444-888888888888"
                                },
                                "uuid": "11111111-2222-3333-4444-888888888888",
                                "name": "sample 3"
                            }
                        },
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