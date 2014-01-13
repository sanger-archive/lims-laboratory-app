# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/tube_rack'
require 'lims-laboratory-app/organization/location'

module Lims::LaboratoryApp
  module Laboratory
    class TubeRack
      class CreateTubeRack
        include Lims::Core::Actions::Action

        %w(row column).each do |w|
          attribute :"number_of_#{w}s", Fixnum, :required => true, :gte => 0, :writer => :private
        end

        attribute :location, Lims::LaboratoryApp::Organization::Location, :default => nil

        # @attribute [Hash<String, Laboratory::Tube>] tubes description
        # @example
        #     {"A1" => tube_1, "B4" => tube_2}
        attribute :tubes, Hash, :default => {}

        def _call_in_session(session)
          tube_rack = Laboratory::TubeRack.new(
            :number_of_columns => number_of_columns,
            :number_of_rows => number_of_rows,
            :location => location
          )
          session << tube_rack

          tubes.each do |position, tube|
            raise TubeInAnotherTubeRack, "The tube in #{position} belongs to another tube rack." if session.tube_rack.belongs_to_tube_rack?(tube) 
            tube_rack[position] = tube
          end

          {:tube_rack => tube_rack, :uuid => session.uuid_for!(tube_rack)}
        end
      end
    end
  end

  module Laboratory
    class TubeRack
      Create = CreateTubeRack
    end
  end
end

