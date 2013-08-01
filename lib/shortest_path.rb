require "shortest_path/version"

module ShortestPath
  class TimeoutError < StandardError
  end
end

require "shortest_path/contextual_node"
require "shortest_path/finder"
require "shortest_path/map"

