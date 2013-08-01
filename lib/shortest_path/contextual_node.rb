module ShortestPath
  class ContextualNode
    attr_reader :context, :node

    def initialize(context, node)
      @context = context
      @node = node
    end
  end
end
