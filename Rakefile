require "rake/testtask"
require "sequel"

task default: :spec

Rake::TestTask.new("spec") do |t|
  t.libs.push ".", "spec"
  t.test_files = FileList["spec/**/*_spec.rb"]
  t.verbose = true
end

desc "Initialize database"
task :init do
  sh "createdb pagan"

  DB = Sequel.connect("postgres://localhost/pagan")

  DB.create_table(:zapps) do
    primary_key :id
    String :name

    index :name
  end
end

desc "Load fixture data"
task :load_fixtures do
  DB = Sequel.connect("postgres://localhost/pagan")

  zapps = DB[:zapps]

  %w(sourcream saltandvinegar plain jalapeno honeymustard bbq).each do |zapp|
    zapps.insert name: zapp
  end
end
