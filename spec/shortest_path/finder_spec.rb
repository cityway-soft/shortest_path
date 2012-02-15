require 'spec_helper'

describe ShortestPath::Finder do
  let(:graph) {
    {   :a => { :e => 3, :b => 1, :c => 3},
                :b => {:e => 1, :a => 1, :c => 3, :d => 5},
                :c => {:a => 3, :b => 3, :d => 1, :s => 3},
                :d => {:b => 5, :c => 1, :s => 1},
                :e => {:a => 3, :b => 1},
                :s => {:c => 3, :d => 1} }
  }

  def shortest_path(source, destination, given_graph = graph)
    ShortestPath::Finder.new(source, destination).tap do |shortest_path|
      shortest_path.ways_finder = Proc.new { |node| given_graph[node] }
    end.path
  end

  it "should find shortest path in an exemple" do
    shortest_path(:e, :s).should == [:e, :b, :c, :d, :s]
  end

  it "should return empty array when unknown start or end" do
    shortest_path(:e, :unknown).should be_empty
    shortest_path(:unknown, :s).should be_empty
    shortest_path(:unknown, :unknown2).should be_empty
  end

  it "should find trivial solution" do
    shortest_path(:a, :b).should == [:a, :b]
  end

  it "should return empty array when graph is not connex" do
    not_connex = graph.clone
    not_connex[:d].delete(:s)
    not_connex[:c].delete(:s)

    shortest_path(:e, :s, not_connex).should be_empty
  end

  subject { 
    ShortestPath::Finder.new(:e, :s).tap do |shortest_path|
      shortest_path.ways_finder = Proc.new {  |node| graph[node] }
    end
  }

  describe "begin_at" do
    
    let(:expected_time) { Time.now }
    
    it "should be defined when path starts" do
      Time.stub :now => expected_time
      subject.path
      subject.begin_at.should == expected_time
    end

  end

  describe "end_at" do
    
    let(:expected_time) { Time.now }
    
    it "should be defined when path ends" do
      Time.stub :now => expected_time
      subject.path
      subject.end_at.should == expected_time
    end

  end

  describe "duration" do
    
    it "should be nil before path is search" do
      subject.duration.should be_nil
    end

    let(:time) { Time.now }

    it "should be difference between Time.now and begin_at when path isn't ended'" do
      Time.stub :now => time
      subject.stub :begin_at => time - 2, :end_at => nil
      subject.duration.should == 2
    end

    it "should be difference between end_at and begin_at when available" do
      subject.stub :begin_at => time - 2, :end_at => time
      subject.duration.should == 2
    end

  end

  describe "timeout?" do

    before(:each) do
      subject.timeout = 2
    end

    it "should be false without timeout" do
      subject.timeout = nil
      subject.should_not be_timeout
    end
    
    it "should be false when duration is lower than timeout" do
      subject.stub :duration => (subject.timeout - 1)
      subject.should_not be_timeout
    end
    
    it "should be true when duration is greater than timeout" do
      subject.stub :duration => (subject.timeout + 1)
      subject.should be_timeout
    end

  end

  describe "path" do
    
    it "should raise a Timeout::Error when timeout?" do
      subject.stub :timeout? => true
      lambda { subject.path }.should raise_error(ShortestPath::TimeoutError)
    end

  end

end
