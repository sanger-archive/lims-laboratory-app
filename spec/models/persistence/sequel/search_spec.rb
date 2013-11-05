#require 'persistence/sequel/store_shared'
require 'integrations/spec_helper'
require 'models/actions/action_examples'

require 'lims-core/persistence/search'
require 'lims-core/persistence/search/create_search'
require 'lims-core/persistence/multi_criteria_filter'
require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/laboratory/plate'

module Lims::Core::Persistence
  describe "Search::CreateSearch" do
    def creating_a_search(description, model, filter)
      store.with_session do |session|
        search = Search.new( :description => description,
                             :model => session.send(model).model,
                             :filter => filter)
        session << search
        uuid = session.uuid_for!(search)
        search
      end
    end

    include_context "use core context service"
    include_context "for application", "search test"

    let(:description)       { "search for a plate by ids" }
    let(:model)             { "plate" }
    let(:condition)         { [1,2] }
    let(:criteria_key)      { "id" }
    let(:filter)            { MultiCriteriaFilter.new(:criteria => { criteria_key => condition}) }
    let!(:existing_search)  { creating_a_search(description, model, filter)}

    subject do
      Search::CreateSearch.new(:store => store, :user => user, :application => application)  do |a,s|
        a.description = description
        a.model       = model
        a.criteria    = { criteria_key => condition }
      end
    end

    context "creating 2 or more similar search should not crash the DB" do
      it {
        store.with_session do |session|
          creating_a_search(description, model, filter).should be_a(Search)
          result = subject.call
          result.should be_a Hash
          result[:search].tap do |returned_search|
            returned_search.description.should == existing_search.description
            returned_search.model.should == existing_search.model
            returned_search.filter.should == existing_search.filter
          end
        end
      }
    end
  end
end
