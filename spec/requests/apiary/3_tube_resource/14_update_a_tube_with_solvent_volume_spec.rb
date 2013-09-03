require "requests/apiary/3_tube_resource/spec_helper"
describe "update_a_tube_with_solvent_volume", :tube => true do
  include_context "use core context service"
  it "update_a_tube_with_solvent_volume" do
    sample = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1')
    tube = Lims::LaboratoryApp::Laboratory::Tube.new << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample)
    
    save_with_uuid sample => [1,2,3,4,6], tube => [1,2,3,4,5]

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = put "/11111111-2222-3333-4444-555555555555", <<-EOD
    {
    "volume": 20
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
        "type": null,
        "max_volume": null,
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
                "quantity": 10,
                "type": "DNA",
                "unit": "mole",
                "out_of_bounds": {
                }
            },
            {
                "quantity": 20,
                "type": "solvent",
                "unit": "ul",
                "out_of_bounds": {
                }
            }
        ]
    }
}
    EOD

  end
end
