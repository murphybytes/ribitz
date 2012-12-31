

module Ribitz

  class Listener
    def self.run( context, opts = {}  )
      begin
        LOGGER.debug "Entered listener thread opts - #{opts}"
        inproc_socket =  context.socket(  ZMQ::PULL )
        binding = opts.fetch(:inproc_binding, "inproc://listener")
        inproc_socket.bind( binding )
        
        listen_socket = context.socket( ZMQ::PULL )
        listen_socket.bind( opts.fetch(:listener_binding) )

        poller = ZMQ::Poller.new
        poller.register_readable( inproc_socket )
        poller.register_readable( listen_socket )

        forward_handler = nil
        if opts.key?(:forward_handler)
          forward_handler = Publisher.new( context, inproc_binding: opts[:forward_handler] ) 
        end

        keep_running = true

        while keep_running
          rc =  poller.poll
          if rc <= 0
            break if ZMQ::Util.errno == ZMQ::EINTR
            raise "Listener poll error - #{ ZMQ::Util.error_string }"
          end

          poller.readables.each do | socket |
            msg = []
            socket.recv_strings msg
            LOGGER.debug "Listener got message #{ msg }"            
            keep_running = handle_message( msg, forward_handler ) 
          end
          
        end

        forward_handler.close if forward_handler
        LOGGER.info "Exiting listen loop"
        ZMQ::Socket.close( inproc_socket )
        ZMQ::Socket.close( listen_socket )
      rescue => e
        LOGGER.error e.backtrace.join("\n")
      end
    end

    def initialize( context, opts = {} )
      @inproc_sender = context.socket( ZMQ::PUSH )

      unless @inproc_sender
        raise "Could not create ZMQ socket"
      end

      rc = @inproc_sender.connect( opts.fetch( :inproc_binding, "inproc://listener") )
      raise ZMQ::Util.error_string if rc < 0 
      
      if block_given? 
        yield self
        self.close 
      end
    end

    def close
      ZMQ::Socket.close( @inproc_sender ) if @inproc_sender
    end

    def send( *msg_parts )
      LOGGER.debug "Listener sending #{msg_parts}"
      @inproc_sender.send_strings msg_parts
    end

    private

    def self.handle_message( msg, forward_handler )
      keep_running = true 

      case msg.shift
      when FORWARD
        forward_handler.send( *msg ) if forward_handler 
      when CONTROL
        case msg.shift
        when SHUTDOWN
          LOGGER.info "Listener recieved shutdown message"
          keep_running = false 
        else 
          LOGGER.warn "Unhandled control message"
        end
      else
        LOGGER.warn "Unhandled message type"
      end
   
      keep_running
    end

  end

end
