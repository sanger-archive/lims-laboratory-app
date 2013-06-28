require "requests/apiary/6_plate_resource/spec_helper"
describe "view_plate", :plate => true do
  include_context "use core context service"
  it "view_plate" do
  # **View a plate.**
  #   Depending on the MIME type parameters, the return JSON will contains more or less informations.
    sample1 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1')
    plate = Lims::LaboratoryApp::Laboratory::Plate.new(:number_of_rows => 8,
                                    :number_of_columns => 12,
                                    :type => "original plate type")
    plate["C5"] << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "sample", :sample => sample1)
    save_with_uuid sample1 => [1,2,3,4,6], plate => [1,2,3,4,5]

    header('Accept', 'application/json ;representation=minimal, application/xml ;level_of_detail=maximum')
    header('Content-Type', 'application/json; representation=minimal')

    response = get "/11111111-2222-3333-4444-555555555555"
    response.should match_json_response(200, <<-EOD) 
    {
    "plate": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555"
    }
}
    EOD

  end
end
