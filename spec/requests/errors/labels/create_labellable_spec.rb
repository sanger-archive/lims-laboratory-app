require "requests/errors/labels/spec_helper"
describe "create_labellable" do
  include_context "use core context service"
  it "Add a label to an asset" do
  # Don't pass a the labellable name
    save_with_uuid Lims::LaboratoryApp::Laboratory::Tube.new => [1,2,3,4,0]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/labellables", <<-EOD
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
        "name": [
            "Name must not be blank"
        ]
    }
}
    EOD

  end
end
