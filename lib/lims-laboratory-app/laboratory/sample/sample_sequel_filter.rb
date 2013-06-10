require 'lims-core/persistence/sequel/filters'
require 'lims-laboratory-app/laboratory/sample/sample_filter'

module Lims::Core
  module Persistence
    # To be able to get a resource by a sample uuid, we need 
    # to follow the following way through the tables to make
    # the right joints.
    # samples -> aliquots -> tube_aliquots -> tubes
    # samples -> aliquots -> wells -> plates
    # samples -> aliquots -> lanes -> flowcells
    # ...
    # Given the model parameter, we need a way to determine the
    # name of the table used to make the join between aliquots and 
    # the table containing the resource. All these tables share two
    # common columns: aliquot_id and resource_id (ex: tube_id). The 
    # first part of the following code analyzes the db structure to
    # find the name of the needed table. For example, if the model
    # is tube, it looks for a table which has these 2 columns:
    # aliquot_id and tube_id.
    module Sequel::Filters
      def sample_filter(criteria)
        resource_id_column = "#{self.table_name.to_s.chomp("s")}_id".to_sym
        sample_uuid = @session.pack_uuid(criteria[:sample]["uuid"])
        through = aliquot_to_resource_table(resource_id_column)

        aliquot_dataset = self.dataset.join(through, resource_id_column => :id).join(:aliquots, :id => :aliquot_id)
        sample_dataset = aliquot_dataset.join(:samples, :id => :sample_id).join(:uuid_resources, :key => :id).where(:uuid_resources__model_class => "sample")

        self.class.new(self, sample_dataset.where(:uuid_resources__uuid => sample_uuid).qualify.distinct)
      end

      def aliquot_to_resource_table(resource_id_column)
        self.dataset.db.tables.each do |table|
          columns = self.dataset.db[table].columns
          return table if columns.include?(resource_id_column) && columns.include?(:aliquot_id)
        end
      end
    end
  end
end


