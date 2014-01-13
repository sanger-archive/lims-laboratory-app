# Spec requirements
require 'lims-laboratory-app/laboratory/container'

require 'models/persistence/sequel/spec_helper'
require 'models/persistence/sequel/store_shared'
require 'models/laboratory/spin_column_shared'
require 'models/persistence/filter/label_sequel_filter_shared'

require 'models/laboratory/location_shared'

# Model requirements
require 'lims-core/persistence/sequel/store'
require 'lims-laboratory-app/laboratory/spin_column'

module Lims::LaboratoryApp
  describe Laboratory::SpinColumn, :spin_column => true, :laboratory => true, :persistence => true, :sequel => true do
    include_context "prepare tables"
    include_context "spin column factory"
    include_context "sequel store"
    
    context "created and added to session" do
      it "modifies the spin column table" do
        expect do
          store.with_session { |session| session << subject }
        end.to change { db[:spin_columns].count }.by(1)
      end

      it "should be reloadable" do
        spin_column_id = save(subject)
        store.with_session do |session|
          spin_column = session.spin_column[spin_column_id]
          spin_column.should eq(session.spin_column[spin_column_id])
        end
      end

      context "created but not added to a session" do
        it "should not be saved" do
          expect do 
            store.with_session { |_| subject }
          end.to change{ db[:spin_columns].count }.by(0)
        end 
      end

      context "already created spin  column" do
        let(:aliquot) { new_aliquot }
        let!(:spin_column_id) { save(subject) }

        context "when modified within a session" do
          before do
            store.with_session do |s|
              spin_column = s.spin_column[spin_column_id]
              spin_column << aliquot
            end
          end
          it "should be saved" do
            store.with_session do |session|
              spin_column = session.spin_column[spin_column_id]
              spin_column.should == [aliquot]
            end
          end
        end

        context "when modified outside a session" do
          before do
            spin_column = store.with_session do |s|
              s.spin_column[spin_column_id]
            end
            spin_column << aliquot
          end
          it "should not be saved" do
            store.with_session do |session|
              spin_column = session.spin_column[spin_column_id]
              spin_column.should be_empty
            end
          end
        end

        context "with a location" do
          include_context "define location"
          subject { Laboratory::SpinColumn.new(:location => location) }

          it "can be saved and reloaded" do
            spin_column_id = save(subject)

            store.with_session do |session|
              spin_column = session.spin_column[spin_column_id]
              spin_column.location.should == location
            end
          end
        end

        context "#lookup by label" do
          let!(:uuid) {
            store.with_session do |session|
              spin_column = session.spin_column[spin_column_id]
              session.uuid_for!(spin_column)
            end
          }

          it_behaves_like "labels filtrable"
        end
      end
    end
  end
end
