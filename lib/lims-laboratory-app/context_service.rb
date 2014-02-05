require 'lims-api/context_service'

require 'lims-laboratory-app/organization/user'

module Lims::Core::Persistence
  class UserSession
    NOT_IN_ROOT = true
  end

  class Revision
    NOT_IN_ROOT = true
  end
end

module Lims::LaboratoryApp
  # Subclass ContextService to extract an Organization::User instead
  # of a string for request params
  class ContextService < Lims::Api::ContextService

    # We need a User adapter class, otherwise
    # the User will be seen as a Resource and so expanded as such
    # in the Json
    class UserAdapter
      attr_reader :user
      def  initialize(user)
        @user = user
      end

      def to_s
        user.email
      end
    end

    def  get_user(request, session)
      user = nil
      super(request, session).andtap do |user_email|

        # Load or create the user if needed
        session.with_session do |session|
          user = session.user[:email => user_email]

          unless user
            session << user = Organization::User.new(:email => user_email)
          end
        end

      end
      UserAdapter.new(user)
    end
  end
end
