require 'models/spec_helper'
require 'lims-laboratory-app/organization/location'

shared_context "can have a location" do
  it_behaves_like "has an attribute of", :location, Lims::LaboratoryApp::Organization::Location
end

shared_context "define location" do
  let(:name)      { "ABC Hospital" }
  let(:address)   { "CB11 3DF Cambridge 123 Sample Way" }
  let(:internal)  { true }
  let(:location)  { Lims::LaboratoryApp::Organization::Location.new(
      :name => name,
      :address => address,
      :internal => internal
  )}
end
