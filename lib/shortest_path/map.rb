module ShortestPath
  class Map

    attr_reader :source
    attr_accessor :max_distance

    def initialize(source)
      @source = source
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

    def map
      @shortest_distances = {}
      @previous = {}

      visited = {}
      pq = PQueue.new { |x,y| search_heuristic(x) < search_heuristic(y) }

      pq.push(source)
      visited[source] = true
      shortest_distances[source] = 0

      while pq.size != 0
        v = pq.pop
        visited[v] = true

        weights = ways(v)
        if weights
          weights.keys.each do |w|
            w_distance = shortest_distances[v] + weights[w]

            if !visited[w] and
                weights[w] and
                ( shortest_distances[w].nil? || shortest_distances[w] > w_distance) and
                follow_way?(v, w, weights[w])
              shortest_distances[w] = w_distance
              previous[w] = v
              pq.push(w)
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
