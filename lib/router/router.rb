$: << File.join( Dir.pwd, 'lib', 'router' )

module Ribitz
  module Router
    class << self
      def run
        LOGGER.info "Running Router"
        LOGGER.debug APP_CONFIG
      end
    end
  end
end
