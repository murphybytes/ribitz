
require 'optparse'
require 'ostruct'
$: << File.join( Dir.pwd, 'lib' )
$: << File.join( Dir.pwd, 'lib', 'ribitz', 'router' )

require 'ribitz'
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
