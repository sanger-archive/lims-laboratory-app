require "requests/apiary/14_assay_resource/spec_helper"
describe "list_actions_for_assay_resource", :assay => true do
  include_context "use core context service"
  it "list_actions_for_assay_resource" do
  # **List actions for snp assay resource.**
  # 
  # * `create` creates a new snp assay via HTTP POST request
  # * `read` returns the list of actions for an snp assay resource via HTTP GET request
  # * `first` lists the first snp assays resources in a page browsing system
  # * `last` lists the last snp assays resources in a page browsing system

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "/snp_assays"
    response.should match_json_response(200, <<-EOD) 
    {
    "snp_assays": {
        "actions": {
            "create": "http://example.org/snp_assays",
            "read": "http://example.org/snp_assays",
            "first": "http://example.org/snp_assays/page=1",
            "last": "http://example.org/snp_assays/page=-1"
        }
    }
}
    EOD

  end
end
