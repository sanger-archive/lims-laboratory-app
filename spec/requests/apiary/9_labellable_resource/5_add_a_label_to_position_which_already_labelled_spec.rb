require "requests/apiary/9_labellable_resource/spec_helper"
describe "add_a_label_to_position_which_already_labelled", :labellable => true do
  include_context "use core context service"
  it "add_a_label_to_position_which_already_labelled" do
  # **Add an already existing label to an asset.**
  # 
  # * `labellable_uuid` unique identifier of an object the labellable related to
  # * `type` the type of the label. It can be 'sanger-barcode', '2d-barcode', 'ean13-barcode' etc...
  # * `value` the value of the barcode
  # * `position` the position of the barcode is an arbitray string (not a Symbol).
    tube = Lims::LaboratoryApp::Laboratory::Tube.new
    labellable = Lims::LaboratoryApp::Labels::Labellable.new(:name => "11111111-2222-3333-4444-000000000000",
                                                        :type => "resource")
    label = Lims::LaboratoryApp::Labels::Labellable::Label.new(:type => "sanger-barcode",
                                                          :value => "1234-ABC")
    labellable["front barcode"] = label
    
    save_with_uuid tube => [1,2,3,4,0], labellable => [1,2,3,4,5]

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = post "/actions/create_label", <<-EOD
    {
    "create_label": {
        "labellable_uuid": "11111111-2222-3333-4444-555555555555",
        "type": "sanger-barcode",
        "value": "1234-ABC",
        "position": "front barcode"
    }
}
    EOD
    response.should match_json_response(422, <<-EOD) 
    {
    "errors": {
        "position": "The front barcode position already contains a label."
    }
}
    EOD

  end
end
