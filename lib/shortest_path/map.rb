require 'fc'

module ShortestPath
  class Map

    attr_reader :source
    attr_accessor :max_distance

    def initialize(source)
      @source = source
      @visited = {}
    end

    # Should return a map with accessible nodes and associated weight
    # Example : { :a => 2, :b => 3 }
    attr_accessor :ways_finder

    def ways(node)
      ways_finder.call node
    end

    def shortest_distances
      @shortest_distances ||= {}
    end

    def previous
      @previous ||= {}
    end

    def search_heuristic(node)
      shortest_distances[node]
    end

    def visited?(node)
      @visited[node]
    end

    def visit(node)
      @visited[node] = true
    end

    def map
      @shortest_distances = {}
      @previous = {}

      pq = ::FastContainers::PriorityQueue.new(:min)

      pq.push(source, 0)
      visit source
      shortest_distances[source] = 0

      while !pq.empty?
        v = pq.pop
        visit v

        weights = ways(v)
        if weights
          weights.keys.each do |w|
            w_distance = shortest_distances[v] + weights[w]
            
            if !visited?(w) and
                weights[w] and
                ( shortest_distances[w].nil? || shortest_distances[w] > w_distance) and
                follow_way?(v, w, weights[w])
              shortest_distances[w] = w_distance
              previous[w] = v
              pq.push(w, search_heuristic(w) )
            end
          end
        end
      end

      shortest_distances
    end

    def follow_way?(node, destination, weight)
      max_distance.nil? or shortest_distances[node] + weight <= max_distance
    end
  end
end
