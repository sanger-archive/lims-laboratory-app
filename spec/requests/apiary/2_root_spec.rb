require "requests/apiary/spec_helper"
describe "root" do
  include_context "use core context service"
  it "root" do
  # --
  # Root
  # --
  # 
  # The root JSON lists all the resources available through the API and all the actions which can be performed. 
  # A resource responds to all the actions listed under its `actions` elements.
  # Consider this URL and the JSON response like the entry point for S2 API. All the other interactions through the 
  # API can be performed browsing this JSON response.

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "/"
    response.should match_json_response(200, <<-EOD) 
    {
    "actions": {
        "read": "http://example.org/"
    },
    "batches": {
        "actions": {
            "create": "http://example.org/batches",
            "read": "http://example.org/batches",
            "first": "http://example.org/batches/page=1",
            "last": "http://example.org/batches/page=-1"
        }
    },
    "users": {
        "actions": {
            "create": "http://example.org/users",
            "read": "http://example.org/users",
            "first": "http://example.org/users/page=1",
            "last": "http://example.org/users/page=-1"
        }
    },
    "studies": {
        "actions": {
            "create": "http://example.org/studies",
            "read": "http://example.org/studies",
            "first": "http://example.org/studies/page=1",
            "last": "http://example.org/studies/page=-1"
        }
    },
    "orders": {
        "actions": {
            "create": "http://example.org/orders",
            "read": "http://example.org/orders",
            "first": "http://example.org/orders/page=1",
            "last": "http://example.org/orders/page=-1"
        }
    },
    "locations": {
        "actions": {
            "create": "http://example.org/locations",
            "read": "http://example.org/locations",
            "first": "http://example.org/locations/page=1",
            "last": "http://example.org/locations/page=-1"
        }
    },
    "samples": {
        "actions": {
            "create": "http://example.org/samples",
            "read": "http://example.org/samples",
            "first": "http://example.org/samples/page=1",
            "last": "http://example.org/samples/page=-1"
        }
    },
    "snp_assays": {
        "actions": {
            "create": "http://example.org/snp_assays",
            "read": "http://example.org/snp_assays",
            "first": "http://example.org/snp_assays/page=1",
            "last": "http://example.org/snp_assays/page=-1"
        }
    },
    "oligos": {
        "actions": {
            "create": "http://example.org/oligos",
            "read": "http://example.org/oligos",
            "first": "http://example.org/oligos/page=1",
            "last": "http://example.org/oligos/page=-1"
        }
    },
    "aliquots": {
        "actions": {
            "create": "http://example.org/aliquots",
            "read": "http://example.org/aliquots",
            "first": "http://example.org/aliquots/page=1",
            "last": "http://example.org/aliquots/page=-1"
        }
    },
    "flowcells": {
        "actions": {
            "create": "http://example.org/flowcells",
            "read": "http://example.org/flowcells",
            "first": "http://example.org/flowcells/page=1",
            "last": "http://example.org/flowcells/page=-1"
        }
    },
    "gels": {
        "actions": {
            "create": "http://example.org/gels",
            "read": "http://example.org/gels",
            "first": "http://example.org/gels/page=1",
            "last": "http://example.org/gels/page=-1"
        }
    },
    "filter_papers": {
        "actions": {
            "create": "http://example.org/filter_papers",
            "read": "http://example.org/filter_papers",
            "first": "http://example.org/filter_papers/page=1",
            "last": "http://example.org/filter_papers/page=-1"
        }
    },
    "fluidigms": {
        "actions": {
            "create": "http://example.org/fluidigms",
            "read": "http://example.org/fluidigms",
            "first": "http://example.org/fluidigms/page=1",
            "last": "http://example.org/fluidigms/page=-1"
        }
    },
    "labellables": {
        "actions": {
            "create": "http://example.org/labellables",
            "read": "http://example.org/labellables",
            "first": "http://example.org/labellables/page=1",
            "last": "http://example.org/labellables/page=-1"
        }
    },
    "sanger_barcodes": {
        "actions": {
            "create": "http://example.org/sanger_barcodes",
            "read": "http://example.org/sanger_barcodes",
            "first": "http://example.org/sanger_barcodes/page=1",
            "last": "http://example.org/sanger_barcodes/page=-1"
        }
    },
    "code128_c_barcodes": {
        "actions": {
            "create": "http://example.org/code128_c_barcodes",
            "read": "http://example.org/code128_c_barcodes",
            "first": "http://example.org/code128_c_barcodes/page=1",
            "last": "http://example.org/code128_c_barcodes/page=-1"
        }
    },
    "ean13_barcodes": {
        "actions": {
            "create": "http://example.org/ean13_barcodes",
            "read": "http://example.org/ean13_barcodes",
            "first": "http://example.org/ean13_barcodes/page=1",
            "last": "http://example.org/ean13_barcodes/page=-1"
        }
    },
    "barcode2_ds": {
        "actions": {
            "create": "http://example.org/barcode2_ds",
            "read": "http://example.org/barcode2_ds",
            "first": "http://example.org/barcode2_ds/page=1",
            "last": "http://example.org/barcode2_ds/page=-1"
        }
    },
    "texts": {
        "actions": {
            "create": "http://example.org/texts",
            "read": "http://example.org/texts",
            "first": "http://example.org/texts/page=1",
            "last": "http://example.org/texts/page=-1"
        }
    },
    "plates": {
        "actions": {
            "create": "http://example.org/plates",
            "read": "http://example.org/plates",
            "first": "http://example.org/plates/page=1",
            "last": "http://example.org/plates/page=-1"
        }
    },
    "spin_columns": {
        "actions": {
            "create": "http://example.org/spin_columns",
            "read": "http://example.org/spin_columns",
            "first": "http://example.org/spin_columns/page=1",
            "last": "http://example.org/spin_columns/page=-1"
        }
    },
    "tubes": {
        "actions": {
            "create": "http://example.org/tubes",
            "read": "http://example.org/tubes",
            "first": "http://example.org/tubes/page=1",
            "last": "http://example.org/tubes/page=-1"
        }
    },
    "tube_racks": {
        "actions": {
            "create": "http://example.org/tube_racks",
            "read": "http://example.org/tube_racks",
            "first": "http://example.org/tube_racks/page=1",
            "last": "http://example.org/tube_racks/page=-1"
        }
    },
    "tag_groups": {
        "actions": {
            "create": "http://example.org/tag_groups",
            "read": "http://example.org/tag_groups",
            "first": "http://example.org/tag_groups/page=1",
            "last": "http://example.org/tag_groups/page=-1"
        }
    },
    "searches": {
        "actions": {
            "create": "http://example.org/searches",
            "read": "http://example.org/searches",
            "first": "http://example.org/searches/page=1",
            "last": "http://example.org/searches/page=-1"
        }
    },
    "sample_filters": {
        "actions": {
            "create": "http://example.org/sample_filters",
            "read": "http://example.org/sample_filters",
            "first": "http://example.org/sample_filters/page=1",
            "last": "http://example.org/sample_filters/page=-1"
        }
    },
    "multi_criteria_filters": {
        "actions": {
            "create": "http://example.org/multi_criteria_filters",
            "read": "http://example.org/multi_criteria_filters",
            "first": "http://example.org/multi_criteria_filters/page=1",
            "last": "http://example.org/multi_criteria_filters/page=-1"
        }
    },
    "label_filters": {
        "actions": {
            "create": "http://example.org/label_filters",
            "read": "http://example.org/label_filters",
            "first": "http://example.org/label_filters/page=1",
            "last": "http://example.org/label_filters/page=-1"
        }
    },
    "order_filters": {
        "actions": {
            "create": "http://example.org/order_filters",
            "read": "http://example.org/order_filters",
            "first": "http://example.org/order_filters/page=1",
            "last": "http://example.org/order_filters/page=-1"
        }
    },
    "batch_filters": {
        "actions": {
            "create": "http://example.org/batch_filters",
            "read": "http://example.org/batch_filters",
            "first": "http://example.org/batch_filters/page=1",
            "last": "http://example.org/batch_filters/page=-1"
        }
    },
    "uuid_resources": {
        "actions": {
            "create": "http://example.org/uuid_resources",
            "read": "http://example.org/uuid_resources",
            "first": "http://example.org/uuid_resources/page=1",
            "last": "http://example.org/uuid_resources/page=-1"
        }
    },
    "create_batches": {
        "actions": {
            "create": "http://example.org/actions/create_batch"
        }
    },
    "create_flowcells": {
        "actions": {
            "create": "http://example.org/actions/create_flowcell"
        }
    },
    "create_gels": {
        "actions": {
            "create": "http://example.org/actions/create_gel"
        }
    },
    "create_filter_papers": {
        "actions": {
            "create": "http://example.org/actions/create_filter_paper"
        }
    },
    "create_fluidigms": {
        "actions": {
            "create": "http://example.org/actions/create_fluidigm"
        }
    },
    "bulk_create_filter_papers": {
        "actions": {
            "create": "http://example.org/actions/bulk_create_filter_paper"
        }
    },
    "create_labels": {
        "actions": {
            "create": "http://example.org/actions/create_label"
        }
    },
    "bulk_create_tubes": {
        "actions": {
            "create": "http://example.org/actions/bulk_create_tube"
        }
    },
    "bulk_create_labellables": {
        "actions": {
            "create": "http://example.org/actions/bulk_create_labellable"
        }
    },
    "create_labellables": {
        "actions": {
            "create": "http://example.org/actions/create_labellable"
        }
    },
    "create_snp_assays": {
        "actions": {
            "create": "http://example.org/actions/create_snp_assay"
        }
    },
    "update_labels": {
        "actions": {
            "create": "http://example.org/actions/update_label"
        }
    },
    "bulk_update_labels": {
        "actions": {
            "create": "http://example.org/actions/bulk_update_label"
        }
    },
    "create_orders": {
        "actions": {
            "create": "http://example.org/actions/create_order"
        }
    },
    "create_plates": {
        "actions": {
            "create": "http://example.org/actions/create_plate"
        }
    },
    "create_searches": {
        "actions": {
            "create": "http://example.org/actions/create_search"
        }
    },
    "create_spin_columns": {
        "actions": {
            "create": "http://example.org/actions/create_spin_column"
        }
    },
    "create_tubes": {
        "actions": {
            "create": "http://example.org/actions/create_tube"
        }
    },
    "create_tube_racks": {
        "actions": {
            "create": "http://example.org/actions/create_tube_rack"
        }
    },
    "plate_transfers": {
        "actions": {
            "create": "http://example.org/actions/plate_transfer"
        }
    },
    "transfer_plates_to_plates": {
        "actions": {
            "create": "http://example.org/actions/transfer_plates_to_plates"
        }
    },
    "transfer_tubes_to_tubes": {
        "actions": {
            "create": "http://example.org/actions/transfer_tubes_to_tubes"
        }
    },
    "transfer_wells_to_tubes": {
        "actions": {
            "create": "http://example.org/actions/transfer_wells_to_tubes"
        }
    },
    "tube_rack_moves": {
        "actions": {
            "create": "http://example.org/actions/tube_rack_move"
        }
    },
    "tube_rack_transfers": {
        "actions": {
            "create": "http://example.org/actions/tube_rack_transfer"
        }
    },
    "update_batches": {
        "actions": {
            "create": "http://example.org/actions/update_batch"
        }
    },
    "update_orders": {
        "actions": {
            "create": "http://example.org/actions/update_order"
        }
    },
    "update_plates": {
        "actions": {
            "create": "http://example.org/actions/update_plate"
        }
    },
    "update_tubes": {
        "actions": {
            "create": "http://example.org/actions/update_tube"
        }
    },
    "update_gels": {
        "actions": {
            "create": "http://example.org/actions/update_gel"
        }
    },
    "update_tube_racks": {
        "actions": {
            "create": "http://example.org/actions/update_tube_rack"
        }
    },
    "delete_tubes": {
        "actions": {
            "create": "http://example.org/actions/delete_tube"
        }
    },
    "delete_tube_racks": {
        "actions": {
            "create": "http://example.org/actions/delete_tube_rack"
        }
    },
    "tag_wells": {
        "actions": {
            "create": "http://example.org/actions/tag_wells"
        }
    },
    "swap_samples": {
        "actions": {
            "create": "http://example.org/actions/swap_samples"
        }
    },
    "transfer_multiple_filter_papers_to_wells": {
        "actions": {
            "create": "http://example.org/actions/transfer_multiple_filter_papers_to_wells"
        }
    },
    "transfer_plates_to_fluidigms": {
        "actions": {
            "create": "http://example.org/actions/transfer_plates_to_fluidigm"
        }
    },
    "move_snp_assays": {
        "actions": {
            "create": "http://example.org/actions/move_snp_assays"
        }
    },
    "create_locations": {
        "actions": {
            "create": "http://example.org/actions/create_location"
        }
    },
    "update_locations": {
        "actions": {
            "create": "http://example.org/actions/update_location"
        }
    },
    "revision": 3
}
    EOD

  end
end
