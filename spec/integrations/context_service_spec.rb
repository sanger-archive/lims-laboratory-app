require 'integrations/spec_helper'
require 'models/persistence/sequel/spec_helper'


module Lims::LaboratoryApp
  describe ContextService do
    context "within a server" do
      include_context "use core context service"
      context "with new user" do
        let(:user_email) { 'new@example.com' }
        it "add the user to the database" do
          header('user_email', user_email)
          header('Accept', 'anything')
          Lims::Api::Context.should_receive(:new) do |*args| #store, bus, application, user, *left|
            user.should_not be_nil
            user.email.should == user_email
          end.and_call_original
          expect {
            get('/')
          }.to change { db[:users].count }.by(1)

          store.with_session do |session|
            user = session.user[:email => user_email]
            user.should_not be_nil
            user.email.should == user_email
          end
        end
      end

      context "with an existing user" do
        let!(:user_email) {
          'existing@user.mail'.tap do |email|
            save(Organization::User.new(:email => email))
          end
        }
        it "load the user from the database" do
          header('user_email', user_email)
          header('Accept', 'anything')
          Lims::Api::Context.should_receive(:new) do |*args| #store, bus, application, user, *left|
            user.should_not be_nil
            user.email.should == user_email
          end.and_call_original
          expect {
            get('/')
          }.to change { db[:users].count }.by(0)
        end
      end
    end
  end
end
