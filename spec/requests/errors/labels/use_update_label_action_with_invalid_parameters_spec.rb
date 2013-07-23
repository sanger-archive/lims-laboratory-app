require "requests/errors/labels/spec_helper"
describe "use_update_label_action_with_invalid_parameters" do
  include_context "use core context service"
  it "use_update_label_action_with_invalid_parameters" do


  # **Use update_label action to update a label with missing parameters for the new label.**
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

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = post "/actions/update_label", <<-EOD
    {
    "update_label": {
        "labellable_uuid": "11111111-2222-3333-4444-555555555555",
        "existing_position": "front barcode",
        "new_label": {
            "test_key": "test_value"
        }
    }
}
    EOD
    response.should match_json_response(422, <<-EOD) 
    {
    "errors": {
        "new_label": "You should provide one or more of the following data in the new_label hash: position, value or type."
    }
}
    EOD

  # **Use update_label action to update a label in a non existing position.**
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

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = post "/actions/update_label", <<-EOD
    {
    "update_label": {
        "labellable_uuid": "11111111-2222-3333-4444-555555555555",
        "existing_position": "not_existing_position",
        "new_label": {
            "position": "rear barcode",
            "type": "sanger-barcode",
            "value": "5678DEF"
        }
    }
}
    EOD
    response.should match_json_response(422, <<-EOD) 
    {
    "errors": {
        "existing_position": "There is no label exist in the 'not_existing_position' position."
    }
}
    EOD

  # **Use update_label action to update a label in a non existing position.**
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

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = post "/actions/update_label", <<-EOD
    {
}
    EOD
    response.should match_json_response(422, <<-EOD) 
    {
    "errors": {
        "update_label": [
            "missing parameter"
        ]
    }
}
    EOD

  # **Use update_label action to update a label in a non existing position.**
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

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = post "/actions/update_label", <<-EOD
    {
    "update_label": {
    }
}
    EOD
    response.should match_json_response(422, <<-EOD) 
    {
    "errors": {
        "labellable": [
            "Labellable must not be blank"
        ],
        "existing_position": [
            "Existing position must not be blank"
        ],
        "new_label": [
            "New label must not be blank"
        ]
    }
}
    EOD

  end
end
