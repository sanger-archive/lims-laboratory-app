# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en 
require 'common'

module Lims::LaboratoryApp
  module Organization
    # A user. Anybody that can log into to the system.
    class User
      include Lims::Core::Resource
      attribute :email, String
    end
  end
end
