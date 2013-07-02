require "requests/apiary/9_labellable_resource/spec_helper"
describe "use_update_laballable_action_to_update_a_label", :labellable => true do
  include_context "use core context service"
  it "use_update_laballable_action_to_update_a_label" do
  # **Use update_labellable action to update a label.**
  # 
  # * `labellable` the labellable resource to update
  # * `name` unique identifier of an asset (for example: uuid of a plate)
  # * `type` type of the object the labellable related (resource, equipment, user etc...)
  # * `labels` it is an array which contains the update information related to the labels
  # * `new_labels` it is a hash which contains the information of the new labels.
  # By labels we mean any readable information found on a physical object.
  # Label can eventually be identified by a position: an arbitray string (not a Symbol).
  # It has a value, which can be serial number, stick label with barcode etc.
  # It has a type, which can be sanger-barcode, 2d-barcode, ean13-barcode etc...
    tube = Lims::LaboratoryApp::Laboratory::Tube.new
    
    labellable = Lims::LaboratoryApp::Labels::Labellable.new(
      :name => "11111111-2222-3333-4444-000000000000",
      :type => "resource")
    label = Lims::LaboratoryApp::Labels::Labellable::Label.new(
      :type => "sanger-barcode",
      :value => "1234-ABC")
    labellable["front barcode"] = label
    
    save_with_uuid tube => [1,2,3,4,0], labellable => [1,2,3,4,5]

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = post "/actions/update_labellable", <<-EOD
    {
    "update_labellable": {
        "labellable_uuid": "11111111-2222-3333-4444-555555555555",
        "name": "11111111-2222-3333-4444-000000000000",
        "type": "updated_resource",
        "labels_to_update": [
            {
                "original_label": {
                    "position": "front barcode",
                    "type": "sanger-barcode",
                    "value": "1234-ABC"
                },
                "value_for_update": "5678DEF"
            }
        ]
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "update_labellable": {
        "actions": {
        },
        "user": "user",
        "application": "application",
        "result": {
            "labellable": {
                "actions": {
                    "read": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "update": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "delete": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "create": "http://example.org/11111111-2222-3333-4444-555555555555"
                },
                "uuid": "11111111-2222-3333-4444-555555555555",
                "name": "11111111-2222-3333-4444-000000000000",
                "type": "updated_resource",
                "labels": {
                    "front barcode": {
                        "value": "5678DEF",
                        "type": "sanger-barcode"
                    }
                }
            }
        },
        "labellable_uuid": "11111111-2222-3333-4444-555555555555",
        "name": "11111111-2222-3333-4444-000000000000",
        "type": "updated_resource",
        "labels_to_update": [
            {
                "original_label": {
                    "position": "front barcode",
                    "type": "sanger-barcode",
                    "value": "1234-ABC"
                },
                "value_for_update": "5678DEF"
            }
        ],
        "new_labels": {
        }
    }
}
    EOD

  end
end
