# Spec requirements
require 'persistence/sequel/spec_helper'

require 'lims-core/labels/labellable/all'
require 'lims-core/persistence/search'

module Lims::LaboratoryApp

  shared_examples_for "labels filtrable" do
    context "with a label" do
      let(:label_position) { "front barcode" }
      let(:label_value) { "01234" }
      let(:label) { Labels::SangerBarcode.new(:value => label_value) }
      let!(:labellable) { 
        store.with_session do |session|
          session << labellable = Labels::Labellable.new(:name => uuid, :type => "resource")
          labellable[label_position] = label
          labellable
        end
      }

      let!(:labellable_resource) { store.with_session { |s| s[uuid] } }
      it "find the resource by label value"  do
        filter = Lims::Core::Persistence::LabelFilter.new(:label => {:value => label_value})
        search = Lims::Core::Persistence::Search.new(:model => labellable_resource.class , :filter => filter, :description => "lookup plate by label value")

        store.with_session do |session|
          results = search.call(session)
          all = results.slice(0,1000).to_a
          all.size.should == 1
          all.first.should == labellable_resource
        end
      end
      it "find the resource by label position" do
        filter = Lims::Core::Persistence::LabelFilter.new(:label => {:position => label_position})
        search = Lims::Core::Persistence::Search.new(:model => labellable_resource.class, :filter => filter, :description => "lookup plate by label value")

        store.with_session do |session|
          results = search.call(session)
          all = results.slice(0,1000).to_a
          all.size.should == 1
          all.first.should == labellable_resource
        end
      end
    end
  end
end
