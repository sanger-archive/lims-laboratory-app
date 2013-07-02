require "requests/errors/laboratory/spec_helper"
describe "create_plate" do
  include_context "use core context service"
  it "Create plate with wrong parameters" do
  # Wrong parameters
    save_with_uuid Lims::LaboratoryApp::Laboratory::Tube.new => [1,2,3,4,0]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/plates", <<-EOD
    {
    "labellable": {
        "type": "resource",
        "labels": {
            "front barcode": {
                "value": "1234-ABC",
                "type": "sanger-barcode"
            }
        }
    }
}
    EOD
    response.should match_json_response(422, <<-EOD) 
    {
    "errors": {
        "plate": [
            "missing parameter"
        ]
    }
}
    EOD

  end
  it "Create plate with dimension missing" do
  # Don't give dimensions
    save_with_uuid Lims::LaboratoryApp::Laboratory::Tube.new => [1,2,3,4,0]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/plates", <<-EOD
    {
    "plate": {
        "number_of_columns": 12,
        "type": "plate type",
        "wells_description": {
        }
    }
}
    EOD
    response.should match_json_response(422, <<-EOD) 
    {
    "errors": {
        "number_of_rows": [
            "Number of rows must be greater than 0"
        ]
    }
}
    EOD

  end
  it "Create plate with dimension not in range" do
  # Negative dimensions
    save_with_uuid Lims::LaboratoryApp::Laboratory::Tube.new => [1,2,3,4,0]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/plates", <<-EOD
    {
    "plate": {
        "number_of_rows": -8,
        "number_of_columns": 12,
        "type": "plate type",
        "wells_description": {
        }
    }
}
    EOD
    response.should match_json_response(422, <<-EOD) 
    {
    "errors": {
        "number_of_rows": [
            "Number of rows must be greater than 0"
        ]
    }
}
    EOD

  end
end
