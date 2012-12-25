$: << File.join( Dir.pwd, 'lib', 'router' )

require 'ffi-rzmq'

module Ribitz
  module Router
    class << self
      def run

        LOGGER.info "Running Router"
        LOGGER.debug APP_CONFIG
        context = ZMQ::Context.create
        # threads = ThreadGroup.new( context )
        # routing = RoutingThread.new( context )
        # notification = NotificationThread.new
        # threads.add( Thread.new { routing.run } )
        # threads.add( Thread.new { notification.run } )
        # threads.join
        
        LOGGER.info "Router exit"
      end
    end
  end
end
