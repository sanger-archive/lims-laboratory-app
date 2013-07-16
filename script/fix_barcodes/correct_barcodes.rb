require 'lims-core/actions/action'
require "#{File.dirname(__FILE__)}/barcode_mapper_constants"
require 'lims-laboratory-app/labels/labellable/update_label'

module Lims::LaboratoryApp
  module Labels
    # Corrects the incorrect label values in the production DBs 
    # (S2 and Sequencescape DBs) and the warehouse according to the given file entries.
    # A file entry is a mapping from the invalid ean13 code to the valid ean13 and sanger code.
    class CorrectBarcodes
      include Lims::Core::Actions::Action
      include BarcodeMapperConstants

      NOT_IN_ROOT = true

      attribute :file_name, String, :required => true, :writer => :private, :initializable => true

      def _call_in_session(session)
        init_db_tables(store.database)

        ean13_sep = BarcodeMapperConstants::EAN13_SEPARATOR
        ean13_sanger_sep = BarcodeMapperConstants::EAN13_SANGER_SEPARATOR
        existing_ean13s = []
  
        File.open(file_name).each_line do |line|
          if /([0-9]+)(#{ean13_sep})([0-9]+)(#{ean13_sanger_sep})([a-zA-Z0-9]+)/ =~ line
            existing_ean13, new_ean13, new_sanger_code = $1, $3, $5
          end

          unless existing_ean13s.include?(existing_ean13)
            existing_ean13s << existing_ean13

            labellable_id_record = @labels_table.select(:labellable_id).where(
              :type => BarcodeMapperConstants::EAN13_BARCODE,
              :value => existing_ean13).first

            raise "EAN13 barcode for the following value is not exist in the DB: #{existing_ean13}" if labellable_id_record.empty?
            labellable_id = labellable_id_record[:labellable_id]

            process_sanger_codes(labellable_id, existing_ean13, new_sanger_code)
            process_ean13_codes(labellable_id, existing_ean13, new_ean13)
          end
        end
      end

      private

      def init_db_tables(db)
        @labels_table = db[:labels]
        @uuid_resources_table = db[:uuid_resources]
      end

      # deals with the sanger barcode fixing
      def process_sanger_codes(labellable_id, existing_ean13, new_sanger_code)
        # gets the existing sanger_code
        existing_sanger_code_records = @labels_table.select(
          :value, :labellable_id, :position).where(
          Sequel.like(:value, "#{new_sanger_code.chop}%"),
          :type           => BarcodeMapperConstants::SANGER_BARCODE,
          :labellable_id  => labellable_id).all

        raise "Sanger barcode for the following EAN13 barcode is not exist in the DB #{existing_ean13}" if existing_sanger_code_records.empty?

        existing_sanger_code_records.each do |existing_sanger_code_record|
          existing_sanger_code = existing_sanger_code_record[:value]
          existing_sanger_position = existing_sanger_code_record[:position]

          # save the existing barcodes to another position so that we have them 
          # to hand in the future if needed.
          move_old_to_new_position(labellable_id, BarcodeMapperConstants::SANGER_BARCODE, existing_sanger_position, existing_sanger_code) if existing_sanger_position

          # correct barcodes (ean13, sanger) in the labels table
          if existing_sanger_position
            new_label_data = { "value" => new_sanger_code}
            correct_the_barcode(labellable_id, existing_sanger_position, new_label_data)
          end
        end
      end

      # deals with the ean13 barcode fixing
      def process_ean13_codes(labellable_id, existing_ean13, new_ean13)
        # gets the existing ean13 position
        existing_ean13_position_record = @labels_table.select(:position).where(
          :type           => BarcodeMapperConstants::EAN13_BARCODE,
          :value          => existing_ean13,
          :labellable_id  => labellable_id).all

        existing_ean13_position_record.each do |existing_ean13_position|
          move_old_to_new_position(labellable_id, BarcodeMapperConstants::EAN13_BARCODE, existing_ean13_position[:position], existing_ean13) if existing_ean13_position[:position]

          if existing_ean13_position[:position]
            new_label_data = { "value" => new_ean13 }
            correct_the_barcode(labellable_id, existing_ean13_position[:position], new_label_data)
          end
        end
      end

      # moves the existing label to a new position to have it later if we need it
      def move_old_to_new_position(labellable_id, type, position, value)
        # creates a 8 character long randon string to add to the label position,
        # so when we move it to another position it won't match to an existing one
        position_suffix = '-' + ('a'..'z').to_a.shuffle[0,8].join
        create_label_action = Lims::LaboratoryApp::Labels::CreateLabel.new(
          :user => user,
          :application => 'barcode fixing',
          :store => store) do |action, session|
            labellable = session.labellable[labellable_id]

            action.labellable = labellable
            action.type       = type
            action.value      = value
            action.position   = "old-"+ position + position_suffix
          end.call
      end

      # update the label's value with the correct ean13 and sanger barcode
      def correct_the_barcode(labellable_id, existing_position, new_label_data)
        create_label_action = Lims::LaboratoryApp::Labels::Labellable::UpdateLabel.new(
          :user => user,
          :application => 'barcode fixing',
          :store => store) do |action, session|
            labellable = session.labellable[labellable_id]

            action.labellable         = labellable
            action.existing_position  = existing_position
            action.new_label          = new_label_data
          end.call
      end

    end
  end
end
