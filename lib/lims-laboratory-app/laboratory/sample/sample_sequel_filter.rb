require 'lims-core/persistence/sequel/filters'
require 'lims-laboratory-app/laboratory/sample/sample_filter'

module Lims::Core
  module Persistence
    module Sequel::Filters
      def sample_filter(criteria)
        resource_id_column = "#{self.table_name.to_s.chomp("s")}_id".to_sym
        aliquot_id_column = "aliquot_id".to_sym

        through = nil
        self.dataset.db.tables.each do |table|
          columns = self.dataset.db[table].columns
          through = table if columns.include?(resource_id_column) && columns.include?(aliquot_id_column)
        end

        aliquot_dataset = self.dataset.join(through, resource_id_column => :id).join(:aliquots, :id => :aliquot_id)
        sample_dataset = aliquot_dataset.join(:samples, :id => :sample_id)

        self.class.new(self, sample_dataset.qualify.distinct)
      end
    end
  end
end


