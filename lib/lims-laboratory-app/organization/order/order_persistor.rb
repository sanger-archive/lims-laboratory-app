# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-core/persistence/persistor'
require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/organization/order'
require 'lims-laboratory-app/organization/study/all'
require 'lims-laboratory-app/organization/user/all'
require 'lims-laboratory-app/organization/batch/all'
require 'lims-laboratory-app/container_persistor_trait'

module Lims::LaboratoryApp
  module Organization
    # Base for all Order persistor.
    class Order
      does "lims/laboratory_app/container_persistor", :element => :item_proxy, :table_name => :items,
      :contained_class => Item
      class OrderPersistor
        def attribute_for(key)
          {creator: 'creator_id',
            study: 'study_id'
          }[key]
        end
        def filter_attributes_on_save(attributes)
          attributes.delete(:items)
          super(attributes) do |k,v|
            case k
            when :parameters, :state then [k, @session.serialize(v)]
            end
          end
        end
        def filter_attributes_on_load(attributes)
          super(attributes) do |k,v|
            case k
            when :parameters, :state then [k, @session.unserialize(v)]
            when :creator_id then  [:creator, @session.user[v]]
            when :study_id then  [:study, @session.study[v]]
            end
          end
        end

        def children_item_proxy(order, children)
          order.each do |role, items|
            items.each do |item|
              item_proxy = ItemProxy.new(order, role, item)
              state = self.item.state_for(item_proxy)
              state.resource = item_proxy
              children << item_proxy
            end
          end
        end

        alias item item_proxy
        class ItemProxy

          SESSION_NAME = :order_item

          def attributes
            @item ?  @item.attributes.merge({order: @order, role: @position}) : {}
          end

          def Xinvalid?
            !@order[@position].include?(@item)
          end

          def on_load
            @order.add_item(@position, @item)
          end



          class ItemProxyPersistor
            def attribute_for(key)
              {order: 'order_id', batch: 'batch_id'
              }[key]
            end
            def filter_attributes_on_save(attributes, *params)
              super(attributes).tap do |attributes|
                attributes[:uuid].andtap do |uuid|
                  attributes[:uuid] = @session.pack_uuid(uuid)
                end
              end
            end

            def filter_attributes_on_load(attributes)
              super(attributes).tap do |attributes|
                attributes[:uuid].andtap do |uuid|
                  attributes[:uuid] = @session.unpack_uuid(uuid) if uuid
                end
              end
            end

            def self.table_name
              :items
            end

            # We can't use yet the default association new_from_attributes method
            # as it thinks Item is a parent or a resource and won't be able 
            # to build it from the attributes.
            def new_from_attributes(_attributes)
              super(filter_attributes_on_load(_attributes)) do |attributes|
                order = @session.order[attributes.delete(:order_id)]
                batch = @session.batch[attributes.delete(:batch_id)]
                role = attributes.delete(:role)
                item = Item.new(attributes)
                item.batch = batch
                order.add_item(role, item)
                Model.new(order, role, item)
              end
            end
            def parents(resource)
              [].tap do |list|
                resource.item.andtap { |i|  i.batch.andtap { |b| list << b } }
            end
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
