# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-core/persistence/persistor'
require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/organization/order'
require 'lims-laboratory-app/organization/study/all'
require 'lims-laboratory-app/organization/user/all'

module Lims::LaboratoryApp
  module Organization
    # Base for all Order persistor.
    class Order
      class OrderPersistor < Lims::Core::Persistence::Persistor
        Model = Organization::Order
          def attribute_for(key)
            {creator: 'creator_id',
             study: 'study_id'
            }[key]
          end

          def parents_for_attributes(attributes)
            [attributes[:creator], attributes[:study]].compact
          end

          def filter_attributes_on_save(attributes)
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

        def children(resource)
          [].tap do |list|
            resource.each do |role, items|
              items.each do |item|
                item_proxy = ItemProxy.new(resource, role, item)
                state = self.item.state_for(item_proxy)
                state.resource = item_proxy
                list << item_proxy
              end
            end
          end
        end

        def deletable_children(resource)
          children(resource)
        end

        def load_children(states, *params)
          #load items
          item.find_by(:order_id => states.map(&:id))
        end

        def item
          @session.order_item
        end
      end

      class ItemProxy
        include Lims::Core::Resource
        attribute :order, Order
        attribute :role, String
        attribute :item, Item


        SESSION_NAME = :order_item

        def initialize(order, role, item)
          @order = order
          @role = role
          @item = item
        end

        def keys
          [@order.object_id, @role, @item.object_id]
        end

        def hash
          keys.hash
        end

        def eql?(other)
          keys == other.keys
        end

        # @speedup
        def attributes
          item.attributes.merge({order: @order, role: @role})
        end

        class ItemProxyPersistor < Lims::Core::Persistence::Persistor
          Model = Organization::Order::ItemProxy

          def attribute_for(key)
            {order: 'order_id', batch: 'batch_id'
            }[key]
          end

          def parents_for_attributesXX(attributes)
            %w(order batch).map { |a| @session.send(a).attributes["#{a}_id"] }
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
        end
        class ItemProxySequelPersistor < ItemProxyPersistor
          include Lims::Core::Persistence::Sequel::Persistor

          def self.table_name
            :items
          end
        end
      end
    end
  end
end
