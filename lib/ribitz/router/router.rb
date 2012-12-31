
require 'ribitz'


module Ribitz
  module Router
    class << self
      def run( opts ) 

        LOGGER.info "Running Router"
        LOGGER.debug APP_CONFIG
        context = ZMQ::Context.create
        listener_binding = "tcp://*:#{APP_CONFIG.fetch('listen-port')}"
        listen_thread = Thread.new { Listener.run( context, {listener_binding:  listener_binding} )  }
        # routing = RoutingThread.new( context )
        # notification = NotificationThread.new
        # threads.add( Thread.new { routing.run } )
        # threads.add( Thread.new { notification.run } )
        listen_thread.join

        ZMQ::Context.close( context ) 
        LOGGER.info "Router exit"
      end
    end
  end
end
