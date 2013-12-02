module Lims::LaboratoryApp
  module Labels
    class Labellable
      module EagerLoadLabellable
        # @param [Lims::Core::Persistence::Persistor] persistor
        # The method load_children of the persistor instance is 
        # overriden to call eager_load_labellables.
        def self.extended(object)
          object.instance_eval do
            alias :load_children_old :load_children
            def load_children(states, *params)
              eager_load_labellables(states, *params)
              load_children_old(states, *params)
            end
          end
        end

        # @param [GroupState] states
        def eager_load_labellables(states, *params)
          load_labellables(states).each do |labellable|
            labelled_resource_state = states.find { |state| state.uuid_resource.uuid == labellable.name }
            next unless labelled_resource_state
            labelled_resource = labelled_resource_state.resource
            bind_labellable(labelled_resource, labellable)
          end
        end

        # @param [GroupState] states
        # @return [Array]
        def load_labellables(states)
          uuid_resources = states.map { |state| @session.uuid_resource_for(state) }.compact
          uuids = uuid_resources.map(&:uuid).map { |uuid| @session.pack_uuid(uuid) }
          @session.labellable.find_by(:name => uuids, :type => "resource")
        end

        # @param [Lims::Core::Resource] resource
        # @param [Labellable] labellable
        def bind_labellable(resource, labellable)
          resource.extend Lims::LaboratoryApp::WithLabellable
          resource.labellable = labellable
        end
      end
    end
  end

  module WithLabellable
    def self.extended(k)
      k.instance_eval do
        class << self
          attr_accessor :labellable
        end
      end
    end
  end
end
