require "requests/apiary/4_tube_rack_resource/spec_helper"
describe "delete_a_tube_rack", :tube_rack => true do
  include_context "use core context service"
  it "delete_a_tube_rack" do
    tube_rack = Lims::LaboratoryApp::Laboratory::TubeRack.new(:number_of_rows => 8, :number_of_columns => 12)
    save_with_uuid tube_rack => [1,2,3,4,5]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = delete "/11111111-2222-3333-4444-555555555555", <<-EOD
    {
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "tube_rack": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "number_of_rows": 8,
        "number_of_columns": 12,
        "tubes": {
        }
    }
}
    EOD

  end
end
