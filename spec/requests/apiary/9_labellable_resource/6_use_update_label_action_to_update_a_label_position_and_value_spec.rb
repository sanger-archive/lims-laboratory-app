require "requests/apiary/9_labellable_resource/spec_helper"
describe "use_update_label_action_to_update_a_label_position_and_value", :labellable => true do
  include_context "use core context service"
  it "use_update_label_action_to_update_a_label_position_and_value" do
  # **Use update_label action to update a label.**
  # 
  # * `labellable` the labellable resource to update
  # * `position` position of the Label to update
  # * `new_label` it is an hash which contains the update information related to the label
  # A hash can contains the new label information (position, type, value).
  # 
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

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/update_label", <<-EOD
    {
    "update_label": {
        "labellable_uuid": "11111111-2222-3333-4444-555555555555",
        "existing_position": "front barcode",
        "new_label": {
            "position": "rear barcode",
            "type": "sanger-barcode",
            "value": "5678DEF"
        }
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "update_label": {
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
                "type": "resource",
                "labels": {
                    "rear barcode": {
                        "value": "5678DEF",
                        "type": "sanger-barcode"
                    }
                }
            }
        },
        "labellable_uuid": "11111111-2222-3333-4444-555555555555",
        "existing_position": "front barcode",
        "new_label": {
            "position": "rear barcode",
            "type": "sanger-barcode",
            "value": "5678DEF"
        }
    }
}
    EOD

  end
end
