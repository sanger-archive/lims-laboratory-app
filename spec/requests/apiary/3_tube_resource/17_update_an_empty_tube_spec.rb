require "requests/apiary/3_tube_resource/spec_helper"
describe "update_an_empty_tube", :tube => true do
  include_context "use core context service"
  it "update_an_empty_tube" do
    tube = Lims::LaboratoryApp::Laboratory::Tube.new
    save_with_uuid tube => [1,2,3,4,5]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = put "/11111111-2222-3333-4444-555555555555", <<-EOD
    {
    "type": "Eppendorf",
    "max_volume": 2
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "tube": {
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

        ]
    }
}
    EOD

  end
end
