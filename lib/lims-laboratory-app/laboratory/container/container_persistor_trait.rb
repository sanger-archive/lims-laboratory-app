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
          attribute :#{parent}, #{parent_class}, :relation => :parent, :skip_parents_for_attributes => true
          attribute :position, Fixnum
          attribute :#{contained}, #{contained_class}, :relation => :parent

          def on_load
            @#{parent}[@position] << @#{contained}
          end

          def invalid?
            !@#{parent}[@position].include?(@#{contained})
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
