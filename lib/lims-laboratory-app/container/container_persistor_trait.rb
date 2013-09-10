require 'lims-core/persistence/persist_association_trait'
require 'lims-core/persistence/sequel/persistor'
module Lims::LaboratoryApp
  module Laboratory
    module Container
      module ContainerPersistorTrait
        as_trait do |args|
          element = args[:element]
          parent_class = self.name.split('::').last
          parent = parent_class.snakecase
          class_name = element.to_s.camelcase
          table_name = args[:table_name]

          contained_class = args.fetch(:contained_class, Aliquot)
          contained = contained_class.name.split('::').last.snakecase
          contained_is_a_resource = contained_class.ancestors.include? Lims::Core::Resource

          delete_contained = args.fetch(:deletable, contained_is_a_resource)

          class_eval <<-EOC
      (does "lims/core/persistence/persistable", :children => [
          {:name => :#{element}, :deletable => true }
        ]).class_eval do


        def children_#{element}(resource, children)
          resource.content.each_with_index do |#{element}, position|
            #{element}.each do |#{contained}|
              #{element} = self.class::#{class_name}.new(resource, position, #{contained})
              state = @session.state_for(#{element})
              state.resource = #{element}
              children << #{element}
            end
          end
        end

        association_class "#{class_name}" do
          attribute :#{parent}, #{self.name}, :relation => :parent, :skip_parents_for_attributes => true
          attribute :position, Object
          attribute :#{contained}, #{contained_class.name},
            :relation => :parent, # #{contained_is_a_resource ? :parent : false},
            :deletable => #{delete_contained}

          def on_load
            @#{parent}[@position] << @#{contained}
          end

          def invalid?
            @position.nil? && @#{contained} != nil ||
              !@#{parent}[@position].andtap { |p| p.include?(@#{contained}) }
          end
        end

        #{
          if table_name
            "
        class self::#{class_name}
          class #{class_name}SequelPersistor < self::#{class_name}Persistor
            include Lims::Core::Persistence::Sequel::Persistor
            def self.table_name
              :#{table_name}
            end
          end
        end
        "
      end
      }
      end
          EOC
        end
      end
    end
  end
end
