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
          class_eval <<-EOC
      (does "lims/core/persistence/persistable", :children => [
          {:name => :#{element}, :deletable => true }
        ]).class_eval do


        def children_#{element}(resource, children)
          resource.content.each_with_index do |#{element}, position|
            #{element}.each do |aliquot|
              #{element} = self.class::#{class_name}.new(resource, position, aliquot)
              state = @session.state_for(#{element})
              state.resource = #{element}
              children << #{element}
            end
          end
        end

        association_class "#{class_name}" do
          attribute :#{parent}, #{parent_class}, :relation => :parent
          attribute :position, Fixnum
          attribute :aliquot, Aliquot, :relation => :parent

          def on_load
            @#{parent}[@position] << @aliquot
          end

          def invalid?
            !@#{parent}[@position].include?(@aliquot)
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
