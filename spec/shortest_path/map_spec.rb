require 'spec_helper'

describe ShortestPath::Map do

  let(:graph) {
    { :a => { :b => 2, :d => 1 },
      :b => { :c => 1, :a => 2 },
      :c => { :b => 1, :d => 3 },
      :d => { :a => 1, :c => 3 } }
  }

  def shortest_path_map(source, max_distance = nil, given_graph = graph)
    ShortestPath::Map.new(source).tap do |shortest_path_map|
      shortest_path_map.max_distance = nil
      shortest_path_map.ways_finder = Proc.new { |node| given_graph[node] }
    end.map
  end

  it "should find shortest path map in an exemple" do
    shortest_path_map(:a).should == { :a => 0, :b => 2, :c => 3, :d => 1 }
  end

end
