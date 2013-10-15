require "requests/apiary/9_labellable_resource/spec_helper"
describe "bulk_update_labels_on_existing_labellable_using_uuids", :labellable => true do
  include_context "use core context service"
  it "bulk_update_labels_on_existing_labellable_using_uuids" do
  # **Bulk update labels on existing labellabels.**
  # 
  # * `labellable_uuid` unique identifier of an object the labellable related to
  # * `type` the type of the label. It can be 'sanger-barcode', '2d-barcode', 'ean13-barcode' etc...
  # * `value` the value of the barcode
  # * `position` the position of the barcode is an arbitray string (not a Symbol).
    filter_paper = Lims::LaboratoryApp::Laboratory::FilterPaper.new(:number_of_rows => 1,
                                    :number_of_columns => 2)
    labellable = Lims::LaboratoryApp::Labels::Labellable.new(:name => "11111111-2222-3333-4444-000000000000",
                                                        :type => "resource")
    label = Lims::LaboratoryApp::Labels::Labellable::Label.new(:type => "sanger-barcode",
                                                          :value => "s1")
    labellable["sanger_id"] = label
    
    save_with_uuid filter_paper => [1,2,3,4,0], labellable => [1,2,3,4,5]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/bulk_update_label", <<-EOD
    {
    "bulk_update_label": {
        "by": "uuid",
        "labels": {
            "11111111-2222-3333-4444-000000000000": {
                "lot_no": {
                    "value": "1",
                    "type": "text"
                },
                "barcode": {
                    "value": "123",
                    "type": "sanger-barcode"
                }
            }
        }
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "bulk_update_label": {
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
                    "name": "11111111-2222-3333-4444-000000000000",
                    "type": "resource",
                    "labels": {
                        "sanger_id": {
                            "value": "s1",
                            "type": "sanger-barcode"
                        },
                        "lot_no": {
                            "value": "1",
                            "type": "text"
                        },
                        "barcode": {
                            "value": "123",
                            "type": "sanger-barcode"
                        }
                    }
                }
            ]
        },
        "by": "uuid",
        "labels": {
            "11111111-2222-3333-4444-000000000000": {
                "lot_no": {
                    "value": "1",
                    "type": "text"
                },
                "barcode": {
                    "value": "123",
                    "type": "sanger-barcode"
                }
            }
        }
    }
}
    EOD

  end
end
