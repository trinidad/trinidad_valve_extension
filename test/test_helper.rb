begin
  require 'bundler/setup'
rescue LoadError
  require 'rubygems'
  require 'bundler/setup'
end
Bundler.require(:default)

require 'test-unit'
require 'mocha'

require "trinidad"

$:.unshift(File.dirname(__FILE__) + '/../lib')
