# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "shortest_path/version"

Gem::Specification.new do |s|
  s.name        = "shortest_path"
  s.version     = ShortestPath::VERSION
  s.authors     = ["Alban Peignier", "Marc Florisson", "Luc Donnet"]
  s.email       = ["alban@tryphon.eu", "mflorisson@cityway.fr", "luc.donnet@free.fr"]
  s.homepage    = "http://github.com/dryade/shortest_path"
  s.summary     = %q{Ruby library to find shortest path(s) in a graph}
  s.description = %q{A* ruby implementation to find shortest path and map}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "guard"
  s.add_development_dependency "guard-bundler"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"

  s.add_dependency "priority_queue_cxx"

end
