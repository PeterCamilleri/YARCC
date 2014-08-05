#!/usr/bin/env rake
require 'rake/testtask'
require 'rdoc/task'

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.rdoc_files = ["lib/yarcc,rb",
                     "license.txt", "README.txt"]
  rdoc.options << '--visibility' << 'private'
end

Rake::TestTask.new do |t|
  t.test_files = ["tests/yarcc_test.rb"]
  t.verbose = false
end

task :reek do |t|
  `reek --no-color lib > reek.txt`
end


