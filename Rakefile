#!/usr/bin/env rake
require "bundler/gem_tasks"

desc "Clean pkg directory"
task(:clean) { sh "rm -rf pkg/" }

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*test.rb']
  t.verbose = true
end

task :default => :test
