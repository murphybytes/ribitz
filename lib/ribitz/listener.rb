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
              break if ZMQ::Util.errno == ZMQ::EINTR
              raise "Listener poll error - #{ ZMQ::Util.error_string }"
            end

            poller.readables.each do | socket |
              msg_parts = []
              socket.recv_strings msg_parts[]
              LOGGER.debug "Listener got message #{ msg_parts }"
            end

          end

          ZMQ::Socket.close( inproc_socket )
          ZMQ::Socket.close( listen_socket )
        rescue => e
          LOGGER.error e.backtrace.join("\n")
        end
      end

      def initialize( context )
        @inproc_sender = context.socket( ZMQ::PUSH )
        unless @inproc_sender
          raise "Could not create ZMQ socket"
        end
        @inproc_sender.connect( "inproc://listener" )
      end

      def close
        ZMQ::Socket.close( @inproc_sender ) if @inproc_sender
      end

      def send( *msg_parts )
        @inproc_sender.send_strings msg_parts
      end


    end

  end 
end
