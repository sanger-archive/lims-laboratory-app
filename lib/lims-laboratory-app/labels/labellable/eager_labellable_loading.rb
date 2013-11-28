module Lims
  module Core::Persistence
    class Persistor
      alias :load_children_old :load_children
      def load_children(states, *params)
        if self.is_a? Lims::Core::Persistence::PersistorModule::EagerLabellableLoading
          eager_load_labellables(states, *params) 
        end

        load_children_old(states, *params)
      end
    end


    module PersistorModule
      module EagerLabellableLoading

        # @param [String] model
        # @return [Bool]
        def self.defined_for?(model)
          labellable_resource_model_names.include?(model)
        end

        # @return [Array]
        # We select the resource which are under the laboratory 
        # namespace and which are Lims::Core::Resource.
        def self.labellable_resource_model_names
          @labellable_resource_model_names ||= Lims::LaboratoryApp::Laboratory.constants.inject([]) do |m,c|
            model_class = Lims::LaboratoryApp::Laboratory.const_get(c)
            model_name = Lims::Core::Persistence::Session.model_to_name(model_class)
            m << model_name if model_class.ancestors.include?(Lims::Core::Resource)
            m
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


  module LaboratoryApp
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
end
