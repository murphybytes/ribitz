module Ribitz
  class Publisher
    def initialize( context, opts = {} )
      LOGGER.debug "instantiating publisher with #{opts}"
      @sock = context.socket( ZMQ::PUSH ) 
      @sock.connect( opts.fetch( :inproc_binding, 'inproc://publisher' ) )

      if block_given?
        yield self
        self.close
      end
    end

    def send( *msg_parts )
      LOGGER.debug "Publisher sending #{msg_parts}"
      @sock.send_strings msg_parts
    end

    def close
      ZMQ::Socket.close( @sock )
      @sock = nil
    end

    def self.run( context, opts = {} )
      begin
        LOGGER.debug "Publisher thread started with #{opts}"
        inproc_sock = context.socket( ZMQ::PULL )
        inproc_sock.bind( opts.fetch( :inproc_binding, 'inproc://publisher' ) )
        
        pub_sock = context.socket( ZMQ::PUB ) 
        pub_sock.bind( opts.fetch( :publisher_binding ) )

        LOGGER.debug "publisher ready to start sending messages"

        keep_running = true

        while keep_running
          msg = []
          rc = inproc_sock.recv_strings( msg )
          LOGGER.debug "Publisher got messages #{ msg }"
          if rc == -1 
            if ZMQ::Util.errno == ZMQ::EINTR 
              LOGGER.info "Received interrupt shutting down"
              break
            end
            raise ZMQ::Util.error_string
          end

          break if msg.first == CONTROL && msg[1] == SHUTDOWN 
          
          rc = pub_sock.send_strings msg
          raise ZMQ::Util.error_string if rc < 0 
        end

        LOGGER.info "Publisher shutting down"
        ZMQ::Socket.close( inproc_sock )
        ZMQ::Socket.close( pub_sock )
        
      rescue => e 
        LOGGER.error e.backtrace.join( "\n" )
      end
    end

  end

end
