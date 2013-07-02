require "requests/errors/labels/spec_helper"
describe "add_labels" do
  include_context "use core context service"
  it "POST" do
  # Add labels to an labellable which doesn't exit.
    tube = Lims::LaboratoryApp::Laboratory::Tube.new
    
    labellable = Lims::LaboratoryApp::Labels::Labellable.new(:name => "11111111-2222-3333-4444-000000000000",
                                                        :type => "resource")
    label = Lims::LaboratoryApp::Labels::Labellable::Label.new(:type => "sanger-barcode",
                                                          :value => "1234-ABC")
    labellable["front barcode"] = label
    
    save_with_uuid tube => [1,2,3,4,0], labellable => [1,2,3,4,5]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/create_label", <<-EOD
    {
    "create_label": {
        "labellable_uuid": "00000000-2222-3333-4444-555555555555",
        "type": "2d-barcode",
        "value": "2d-barcode-1234",
        "position": "rear barcode"
    }
}
    EOD
    response.should match_json_response(422, <<-EOD) 
    {
    "errors": {
        "labellable_uuid": [
            "value '00000000-2222-3333-4444-555555555555' is invalid"
        ]
    }
}
    EOD

  end
  it "POST" do
  # Add labels but forget to specify the labellable.
    tube = Lims::LaboratoryApp::Laboratory::Tube.new
    
    labellable = Lims::LaboratoryApp::Labels::Labellable.new(:name => "11111111-2222-3333-4444-000000000000",
                                                        :type => "resource")
    label = Lims::LaboratoryApp::Labels::Labellable::Label.new(:type => "sanger-barcode",
                                                          :value => "1234-ABC")
    labellable["front barcode"] = label
    
    save_with_uuid tube => [1,2,3,4,0], labellable => [1,2,3,4,5]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/create_label", <<-EOD
    {
    "create_label": {
        "type": "2d-barcode",
        "value": "2d-barcode-1234",
        "position": "rear barcode"
    }
}
    EOD
    response.should match_json_response(422, <<-EOD) 
    {
    "errors": {
        "labellable": [
            "Labellable must not be blank"
        ]
    }
}
    EOD

  end
end
