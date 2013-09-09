require 'lims-laboratory-app/labels/labellable'
require 'lims-laboratory-app/laboratory/container/container_persistor_trait'

# needs to require all label subclasses
require 'lims-laboratory-app/labels/sanger_barcode'

module Lims::LaboratoryApp
  module Labels
    class Labellable
      does "lims/laboratory_app/laboratory/container/container_persistor", :element => :label_proxy, :table_name => :labels,
      :contained_class => Object
      class LabellablePersistor
        # Saves all children of a given Labellable
        def children_label_proxy(labellable, children)
          labellable.map do |position, label_object|
            proxy = LabelProxy.new(labellable, position, label_object)
            state = @session.state_for(proxy)
            state.resource = proxy
            children << proxy
          end
        end

        def filter_attributes_on_save(attributes, *params)
          attributes.delete(:content)
          if attributes[:type] == "resource"
            name = attributes[:name]
            attributes[:name] = @session.pack_uuid(name)
          end
          attributes
        end

        def filter_attributes_on_load(attributes, *params)
          if attributes[:type] == "resource"
            name = attributes[:name]
            attributes[:name] = @session.unpack_uuid(name)
          end
          attributes
        end

        alias label label_proxy

        class LabelProxy
          def attributes
            (@labellable[@position].andtap do |label|
                label.attributes
              end || {}).tap do |att| 
                att[:position]=@position
                att[:labellable]=@labellable
            end
          end

          def invalid?
            @labellable[@position] != @object
          end

          class LabelProxyPersistor
            def on_load
              @labellable[@position] = Label.new(@object)
            end

            # General behavior for a proxy class
            def new_from_attributes(attributes)
              labellable = @session.labellable[attributes.delete(:labellable_id)]
              position = attributes.delete(:position)
              super(attributes) do |att|
                label = Label.new(att)
                labellable[position] = label
                model.new(labellable, position)
              end
            end

            def parents(resource)
              super(resource)
            end

            def parents_for_attributes(att)
              []
            end
          end
        end
      end
    end
  end
end
