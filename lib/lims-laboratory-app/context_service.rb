require 'lims-api/context_service'

require 'lims-laboratory-app/organization/user'

module Lims::LaboratoryApp
  # Subclass ContextService to extract an Organization::User instead
  # of a string for request params
  class ContextService < Lims::Api::ContextService
    def  get_user(request)
      user = nil
      super(request).andtap do |user_email|

        # Load or create the user if needed
        @store.with_session do |session|
          user = session.user[:email => user_email]

          unless user
            session << user = Organization::User.new(:email => user_email)
          end
        end

      end
      user
    end
  end
end
