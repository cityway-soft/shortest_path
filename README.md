# Shortest Path
[![Build Status](https://travis-ci.org/dryade/shortest_path.png)](http://travis-ci.org/dryade/shortest_path?branch=master) [![Dependency Status](https://gemnasium.com/dryade/shortest_path.png)](https://gemnasium.com/dryade/shortest_path) [![Code Climate](https://codeclimate.com/github/dryade/shortest_path.png)](https://codeclimate.com/github/dryade/shortest_path) [![Coverage Status](https://img.shields.io/coveralls/dryade/shortest_path.svg)](https://coveralls.io/r/dryade/shortest_path)

A* ruby implementation to find shortest path and map in a graph with :
 - a timeout to stop research when duration > timeout
 - a context in a hash for each point in the graph
 - the possibility to override default methods 


Requirements
------------
 
This code has been run and tested on Ruby 1.9 or later

External Deps
-------------
On Debian/Ubuntu/Kubuntu OS : 
```sh
sudo apt-get install git
```

gcc is for priority queue. 

Installation
------------
 
This package is available in RubyGems and can be installed with:
```sh 
gem install shortest_path
```

Test
----

```sh
bundle exec rake spec
```

More Information
----------------
 
More information can be found on the [project website on GitHub](http://github.com/dryade/shortest_path). 
There is extensive usage documentation available [on the wiki](https://github.com/dryade/shortest_path/wiki).

Example Usage 
-------------

Create a basic shortest path finder : 
```ruby
# Create a graph
graph = {   :a => { :e => 3, :b => 1, :c => 3},
                :b => {:e => 1, :a => 1, :c => 3, :d => 5},
                :c => {:a => 3, :b => 3, :d => 1, :s => 3},
                :d => {:b => 5, :c => 1, :s => 1},
                :e => {:a => 3, :b => 1},
                :s => {:c => 3, :d => 1} }
}

# Create a finder
finder = ShortestPath::Finder.new(:a, :e).tap do |shortest_path|
  shortest_path.ways_finder = Proc.new { |node| graph[node] }
end

# Change the timeout in seconds
finder.timeout = 2

# Call graph result
finder.path

```

Overwrite shortest path finder : 
```ruby

# TODO : Class that overwrites shortest path finder
...


```


License
-------
 
This project is licensed under the MIT license, a copy of which can be found in the LICENSE file.

Support
-------
 
Users looking for support should file an issue on the GitHub issue tracking page (https://github.com/dryade/shortest_path/issues), or file a pull request (https://github.com/dryade/shortest_path/pulls) if you have a fix available.
