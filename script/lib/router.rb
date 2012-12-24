require 'yaml'

$: << File.join( Dir.pwd, 'lib', 'router' )

ENV['RIBITZ_ENV'] ||= 'development'
APP_CONFIG=YAML.load_file('config/router.yaml')[ENV['RIBITZ_ENV']]

require 'logger'

logfile = APP_CONFIG['log-file']

LOGGER = Logger.new( File.open( logfile, File::WRONLY | File::APPEND ) ) if logfile
LOGGER = Logger.new( STDOUT ) unless logfile 
LOGGER.level = case APP_CONFIG.fetch('log-level', 'DEBUG' ).upcase
                 when 'DEBUG' then Logger::DEBUG
                 when 'INFO' then Logger::INFO
                 when 'WARN' then Logger::WARN
                 when 'ERROR' then Logger::ERROR
                 when 'FATAL' then Logger::FATAL
                 else Logger::INFO
               end

require 'router'

Ribitz::Router.run
