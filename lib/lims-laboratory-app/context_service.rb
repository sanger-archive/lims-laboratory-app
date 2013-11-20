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
      def  initialize(user, id)
        @user = user
        @user_id = id
      end

      def to_s
        @user.email
      end

      # Quick hack to reload the user
      # in a new session.
      def user(session)
        session.user[@user_id]
      end
    end

    def  get_user(request)
      user, user_id = nil, nil
      super(request).andtap do |user_email|

        # Load or create the user if needed
        user_id = @store.with_session do |session|
          user = session.user[:email => user_email]

          unless user
            session << user = Organization::User.new(:email => user_email)
          end
          lambda { session.id_for(user) }
        end.call

      end
      UserAdapter.new(user, user_id)
    end
  end
end
