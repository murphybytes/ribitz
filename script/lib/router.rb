require 'yaml'
require 'optparse'
require 'ostruct'

$: << File.join( Dir.pwd, 'lib', 'ribitz', 'router' )

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

options = {}

parser = OptionParser.new do | opts |
  opts.banner = "Usage: router [options]"
  opts.separator ""
  opts.separator "Specific Options:"

  opts.on("-f", "--graph-file FILE", "Path of graph file" ) do | val |
    options[:graph_file] = val
  end

  opts.on("--active-router [BINDING]", "ZMQ binding for active router. Supplying this option will run router as passive or backup router in a high availability pair" ) do | val |
    options[:active_router] = val
  end

  opts.on( "--passive-router [BINDING]", "ZMQ binding for passive router.  Supplying this option will run router as primary in a high availability pair" ) do | val |
    options[:passive_router] = val
  end

  opts.on_tail("-h", "--help", "Show this message" ) do 
    puts opts
    exit
  end
end

parser.parse!(ARGV)

Ribitz::Router.run options
