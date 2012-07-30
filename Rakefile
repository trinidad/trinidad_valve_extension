require 'bundler/setup'
Bundler::GemHelper.install_tasks

desc "Clean pkg directory"
task(:clean) { sh "rm -rf pkg/" }

task :default => :test

task(:test) do
  test = ENV['TEST'] || File.join(Dir.getwd, "test/**/*_test.rb")
  test_opts = (ENV['TESTOPTS'] || '').split(' ')
  test_opts = test_opts.push *FileList[test].to_a
  ruby "-Isrc/main/ruby:src/test/ruby", "-S", "testrb", *test_opts
end
