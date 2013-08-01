require 'pqueue'

module ShortestPath
  class Finder

    attr_reader :source, :destination

    def initialize(source, destination)
      @source, @destination = source, destination
      @visited = {}
    end

    # Should return a map with accessible nodes and associated weight
    # Example : { :a => 2, :b => 3 }
    attr_accessor :ways_finder

    def refresh_context( node, context)
        {}
    end

    def ways(node, context={})
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

    def follow_way?(node, destination, weight, context={})
      true
    end

    attr_accessor :timeout
    attr_reader :begin_at, :end_at

    def timeout?
      timeout and (duration > timeout)
    end

    def duration
      return nil unless begin_at
      (end_at or Time.now) - begin_at
    end

    def visited?(node)
      @visited[node]
    end

    def visit(node)
      @visited[node] = true
    end

    def found?(node)
      node == destination
    end

    def path_without_cache
      @begin_at = Time.now

      visited = {}
      pq = PQueue.new do |x,y|
        search_heuristic(x.node) < search_heuristic(y.node)
      end

      pq.push( ContextualNode.new( {}, source))
      visit source
      shortest_distances[source] = 0

      not_found = !found?(source)

      while pq.size != 0 && not_found
        raise TimeoutError if timeout?

        contextual_node = pq.pop
        v = contextual_node.node
        puts "pq.pop #{v} #{contextual_node.context.inspect} shortest_distances #{shortest_distances[v]}"
        not_found = !found?(v)
        visit v

        weights = ways(v, contextual_node.context)
        if weights
          weights.keys.each do |w|
            if !visited?(w) and
                weights[w] and
                ( shortest_distances[w].nil? || shortest_distances[w] > shortest_distances[v] + weights[w]) and
                follow_way?(v, w, weights[w], contextual_node.context)
              shortest_distances[w] = shortest_distances[v] + weights[w]
              previous[w] = v
              refreshed_context = refresh_context( w, contextual_node.context)
        puts "pq.push #{w} #{refreshed_context.inspect} shortest_distances =#{shortest_distances[w]}"
              pq.push( ContextualNode.new( refreshed_context, w))
            end
          end
        end
      end

      @end_at = Time.now
      not_found ? [] : sorted_array
    end

    def path_with_cache
      @path ||= path_without_cache
    end
    alias_method :path, :path_with_cache

    def sorted_array
      [].tap do |sorted_array|
        previous_id = destination
        previous.size.times do |t|
          sorted_array.unshift(previous_id)
          break if previous_id == source
          previous_id = previous[previous_id]
          raise "Unknown #{previous_id.inspect}" unless previous_id
        end
      end
    end
  end
end
