module Lims::Core
  module Persistence
    module PersistorModule
      module EagerLabellableLoading
        include BasePersistorModule

        def self.defined_for?(model)
          ["tube"].include?(model)
        end

        def call_persistor_module(states)
          super(states)
          uuid_resources = states.map { |state| @session.uuid_resource_for(state) }
          uuids = uuid_resources.map(&:uuid).map { |uuid| @session.pack_uuid(uuid) }
          @session.labellable.find_by(:name => uuids, :type => "resource")
        end

        def bind(resource, labellable)
          resource.extend Labellable
          resource.labellable = labellable
        end

        module Labellable
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
