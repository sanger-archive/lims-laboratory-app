require 'modularity'
require 'lims-core/persistence/persistable_trait'
require 'lims-core/persistence/state_group'

module Lims
  module LaboratoryApp
    module PersistableLabellableTrait
      as_trait do |args|

        persistor_class = class_eval <<-EOC
          does "lims/core/persistence/persistable", #{args}
        EOC

        model_name = self.name.split('::').last
        class_eval <<-EOC
          class #{model_name}Persistor
            # @param [StateGroup] states
            # @return [Array]
            # Load all the labellables in the session for resources
            # in the state group.
            def load_labellables(states)
              uuid_resources = states.map { |state| @session.uuid_resource_for(state) }
              uuids = uuid_resources.map(&:uuid).map { |uuid| @session.pack_uuid(uuid) }
              @session.labellable.find_by(:name => uuids, :type => "resource")
            end

            def load_labellables?
              true
            end

            # @param [Lims::Core::Resource] resource
            # @param [Labellable] labellable
            def attach_labellable(resource, labellable)
              resource.labellable = labellable
            end
          end
        EOC

        persistor_class
      end
    end
  end

  module Core
    module Resource
      module Labellable
        def self.included(klass)
          klass.class_eval do
            attr_accessor :labellable
          end
        end
      end
      include Labellable
    end

    module Persistence
      class Persistor
        def load_labellables?
          false
        end
      end

      class StateGroup
        alias :load_old :load
        def load(*params)
          load_old(*params).tap do
            if persistor.load_labellables? 
              persistor.load_labellables(self).tap do |labellables|
                labellables.each do |labellable|
                  labelled_resource_state = self.find { |state| state.uuid_resource.uuid == labellable.name }
                  next unless labelled_resource_state
                  labelled_resource = labelled_resource_state.resource
                  persistor.attach_labellable(labelled_resource, labellable)
                end
              end
            end
          end
        end
      end
    end
  end
end
