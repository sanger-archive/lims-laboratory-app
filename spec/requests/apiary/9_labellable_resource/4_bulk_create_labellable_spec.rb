require "requests/apiary/9_labellable_resource/spec_helper"
describe "bulk_create_labellable", :labellable => true do
  include_context "use core context service"
  it "bulk_create_labellable" do
    save_with_uuid({
      Lims::LaboratoryApp::Laboratory::Tube.new => [1,0,0,0,1],
      Lims::LaboratoryApp::Laboratory::Tube.new => [1,0,0,0,2],
      Lims::LaboratoryApp::Laboratory::Tube.new => [1,0,0,0,3]
    })

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = post "/actions/bulk_create_labellable", <<-EOD
    {
    "bulk_create_labellable": {
        "labellables": [
            {
                "name": "11111111-0000-0000-0000-111111111111",
                "type": "resource",
                "labels": {
                    "front barcode": {
                        "value": "1234-ABC",
                        "type": "sanger-barcode"
                    }
                }
            },
            {
                "name": "11111111-0000-0000-0000-222222222222",
                "type": "resource",
                "labels": {
                    "front barcode": {
                        "value": "5678-DEF",
                        "type": "ean13-barcode"
                    }
                }
            },
            {
                "name": "11111111-0000-0000-0000-333333333333",
                "type": "resource",
                "labels": {
                    "front barcode": {
                        "value": "9101-GHI",
                        "type": "ean13-barcode"
                    }
                }
            }
        ]
    }
}
    EOD
    response.status.should == 200
    response.body.should match_json <<-EOD
    {
    "bulk_create_labellable": {
        "actions": {
        },
        "user": "user",
        "application": "application",
        "result": {
            "labellables": [
                {
                    "actions": {
                        "read": "http://example.org/11111111-2222-3333-4444-555555555555",
                        "create": "http://example.org/11111111-2222-3333-4444-555555555555",
                        "update": "http://example.org/11111111-2222-3333-4444-555555555555",
                        "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
                    },
                    "uuid": "11111111-2222-3333-4444-555555555555",
                    "name": "11111111-0000-0000-0000-111111111111",
                    "type": "resource",
                    "labels": {
                        "front barcode": {
                            "value": "1234-ABC",
                            "type": "sanger-barcode"
                        }
                    }
                },
                {
                    "actions": {
                        "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "create": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "delete": "http://example.org/11111111-2222-3333-4444-666666666666"
                    },
                    "uuid": "11111111-2222-3333-4444-666666666666",
                    "name": "11111111-0000-0000-0000-222222222222",
                    "type": "resource",
                    "labels": {
                        "front barcode": {
                            "value": "5678-DEF",
                            "type": "ean13-barcode"
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
                    "name": "11111111-0000-0000-0000-333333333333",
                    "type": "resource",
                    "labels": {
                        "front barcode": {
                            "value": "9101-GHI",
                            "type": "ean13-barcode"
                        }
                    }
                }
            ]
        },
        "labellables": [
            {
                "name": "11111111-0000-0000-0000-111111111111",
                "type": "resource",
                "labels": {
                    "front barcode": {
                        "value": "1234-ABC",
                        "type": "sanger-barcode"
                    }
                }
            },
            {
                "name": "11111111-0000-0000-0000-222222222222",
                "type": "resource",
                "labels": {
                    "front barcode": {
                        "value": "5678-DEF",
                        "type": "ean13-barcode"
                    }
                }
            },
            {
                "name": "11111111-0000-0000-0000-333333333333",
                "type": "resource",
                "labels": {
                    "front barcode": {
                        "value": "9101-GHI",
                        "type": "ean13-barcode"
                    }
                }
            }
        ]
    }
}
    EOD

  end
end
