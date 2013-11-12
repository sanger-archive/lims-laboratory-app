require 'lims-api/context_service'

require 'lims-laboratory-app/organization/user'

module Lims::LaboratoryApp
  # Subclass ContextService to extract an Organization::User instead
  # of a string for request params
  class ContextService < Lims::Api::ContextService

    # We need a User adapter class, otherwise
    # the User will be seen as a Resource and so expanded as such
    # in the Json
    class UserAdapter
      def  initialize(user, user_uuid)
        @user = user
        @user_uuid = user_uuid
      end

      def to_s
        @user.email
      end

      # Quick hack to reload the user
      # in a new session.
      def user(session)
        session[@user_uuid]
      end
    end

    def  get_user(request)
      user, user_uuid = nil, nil
      super(request).andtap do |user_email|

        # Load or create the user if needed
        @store.with_session do |session|
          user = session.user[:email => user_email]

          unless user
            session << user = Organization::User.new(:email => user_email)
          end
          user_uuid = session.uuid_for!(user)
        end

      end
      UserAdapter.new(user, user_uuid)
    end
  end
end
