require 'ffi-rzmq'

module Ribitz
  module Router 

    class Listener
      def self.run( context, opts = {} )
        begin
          LOGGER.debug "Entered listener thread opts - #{opts}"
          inproc_socket =  context.socket(  ZMQ::PULL )
          LOGGER.debug "created inproc socket"
          inproc_socket.bind( "inproc://listener" )
          LOGGER.debug "created inproc binding" 

          listen_socket = context.socket( ZMQ::PULL )
          LOGGER.info( "Listen binding #{ opts.fetch( :listener_binding ) }" )
          listen_socket.bind( opts.fetch(:listener_binding) )

          LOGGER.debug "Listener sockets created"
          
          poller = ZMQ::Poller.new
          poller.register_readable( inproc_socket )
          poller.register_readable( listen_socket )
          
          while true

            if poller.poll == -1 
              raise "Listener poll error - #{ ZMQ::Util.error_string }"
            end

            poller.readables.each do | socket |
              msg = ""
              socket.recv_string msg
              LOGGER.debug "Listener got message #{ msg }"
            end
            
          end

          ZMQ::Socket.close( inproc_socket )
        rescue => e
          LOGGER.error e.backtrace.join("\n")
        end        
      end

      def self.send( msg )
      end


    end

  end 
end
