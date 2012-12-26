
module Ribitz
  module Router
    class Node
      attr_reader :name, :children, :parents
      
      def initialize( worker_type )
        @name = worker_type
        @children  = {}
        @parents = {}
      end

      def add_child( node )
        @children[node.name] = node
      end
      
      def add_parent( node )
        @parents[node.name] = node
      end
    end
  end 
end
