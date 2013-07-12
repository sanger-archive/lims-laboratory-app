require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = '--color'
end

namespace :db do
  require 'sequel'
  require 'sequel/extensions/migration'
  core_migrations_path = "#{Dir.pwd}/db/migrations"

  task :test do
    Sequel::Migrator.apply(Sequel.sqlite('test.db'), core_migrations_path)
  end

  task :dev do
    Sequel::Migrator.apply(Sequel.sqlite('dev.db'), core_migrations_path)
  end

  task :seed_test_data_for_barcode_fix do
    sh "rm dev.db | make migrate_dev | bundle exec ruby script/fix_barcodes/seed_test_data.rb"
  end
end

task :default => [ 'db:test', :spec ]
task :migrate_test => [ 'db:test' ]
task :migrate_dev => [ 'db:dev' ]
task :seed_barcode_fix => [ 'db:seed_test_data_for_barcode_fix' ]
