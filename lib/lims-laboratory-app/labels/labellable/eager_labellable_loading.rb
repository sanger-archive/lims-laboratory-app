require 'lims-core/persistence/persistor_module'

module Lims::Core
  module Persistence
    module PersistorModule
      module EagerLabellableLoading

        def self.defined_for?(model)
          ["tube"].include?(model)
        end

        def eager_labellable_loading(states, *params)
          load_labellables(states).each do |labellable|
            labelled_resource_state = states.find { |state| state.uuid_resource.uuid == labellable.name }
            next unless labelled_resource_state
            labelled_resource = labelled_resource_state.resource
            bind(labelled_resource, labellable)
          end
        end

        def load_labellables(states)
          uuid_resources = states.map { |state| @session.uuid_resource_for(state) }
          uuids = uuid_resources.map(&:uuid).map { |uuid| @session.pack_uuid(uuid) }
          @session.labellable.find_by(:name => uuids, :type => "resource")
        end

        def bind(resource, labellable)
          resource.extend LabelledResource
          resource.labellable = labellable
        end

        module LabelledResource
          def self.extended(k)
            k.instance_eval do
              class << self
                attr_accessor :labellable
              end
            end
          end
        end
      end
    end
  end
end
