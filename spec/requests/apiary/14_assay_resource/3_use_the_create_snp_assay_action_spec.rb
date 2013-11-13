require "requests/apiary/14_assay_resource/spec_helper"
describe "use_the_create_snp_assay_action", :assay => true do
  include_context "use core context service"
  it "use_the_create_snp_assay_action" do
  # **Use the createn snp assay action.**
  # 
  # * `name` the name of the snp assay
  # * `allele_x` a group of genes. Its value can be A, C, G or T.
  # * `allele_y` a group of genes. Its value can be A, C, G or T.

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/create_snp_assay", <<-EOD
    {
    "create_snp_assay": {
        "name": "snp assay name",
        "allele_x": "G",
        "allele_y": "A"
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "create_snp_assay": {
        "actions": {
        },
        "user": "user",
        "application": "application",
        "result": {
            "snp_assay": {
                "actions": {
                    "read": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "update": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "delete": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "create": "http://example.org/11111111-2222-3333-4444-555555555555"
                },
                "uuid": "11111111-2222-3333-4444-555555555555",
                "name": "snp assay name",
                "allele_x": "G",
                "allele_y": "A"
            },
            "uuid": "11111111-2222-3333-4444-555555555555"
        },
        "name": "snp assay name",
        "allele_x": "G",
        "allele_y": "A"
    }
}
    EOD

  end
end
