
require 'node'

module Ribitz
  module Router
    class Graph

      def initialize graph_string 
        parse( graph_string )
        
      end

      def worker_names
        @nodes.keys
      end

      def worker( worker_name  )
        @nodes.fetch( worker_name )
      end

      private

      def get_node( key )
        @nodes.fetch( key ) do | k |
          @nodes[k] = Node.new( k ) 
        end
      end
      
      def parse( graph_string ) 

        @nodes = {}

        graph_string.split( "\n" ).each do | line |
          line.strip!
          line.squeeze!( " " )
          root = nil

          line.split( " " ).each do | worker_type |
            if root 
              child = get_node( worker_type )
              root.add_child( child )
              child.add_parent( root )
            else
              root = get_node( worker_type )
            end
          end

        end

      end

      

    end
  end
end
