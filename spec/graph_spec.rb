require File.join( File.dirname(__FILE__), %w[spec_helper] )

require 'graph'

include Ribitz::Router

describe Graph do 
  it "should parse a graph string" do
    graph_string = "A B C\nB D\nC D\n"
    g = Graph.new( graph_string )
    g.worker_names.length.should eq 4
    g.worker( "A" ).children.length.should eq 2
    g.worker( "A" ).children.key?( "B" ).should be_true
    g.worker( "A" ).children.key?( "C" ).should be_true
    g.worker( "B" ).parents.key?( "A" ).should be_true
    g.worker( "B" ).parents.key?( "D" ).should be_false
    g.worker( "D" ).parents.length.should eq 2
    g.worker( "D" ).parents.key?( "C" ).should be_true
  end
end

