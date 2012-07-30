require 'bundler/setup'

require 'test/unit'
require 'mocha'

require "trinidad"

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'trinidad_valve_extension'