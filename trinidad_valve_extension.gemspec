# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "trinidad_valve_extension/version"

Gem::Specification.new do |s|
  s.name              = 'trinidad_valve_extension'
  s.version           = Trinidad::Extensions::Valve::VERSION
  s.rubyforge_project = 'trinidad_valve_extension'
  
  s.summary     = "Trinidad extension to add and configure Tomcat valves"
  s.description = "Trinidad extension to add and configure Tomcat valves. " + 
  "Built-in Tomcat valves are always available but any valve present in the class-path can be used."
  
  s.authors  = ["Michael Leinartas"]
  s.email    = 'mleinartas@gmail.com'
  s.homepage = 'http://github.com/trinidad/trinidad_valve_extension'
  
  s.require_paths = %w[lib]
  s.files = `git ls-files`.split("\n")
  
  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[ README.md LICENSE ]
  
  s.add_dependency('trinidad', '>= 1.3.5')
  
  s.add_development_dependency('rake')
  s.add_development_dependency('test-unit')
  s.add_development_dependency('mocha')
end
