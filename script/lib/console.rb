$: << File.join( Dir.pwd, 'lib' )
$: << File.join( Dir.pwd, 'lib', 'ribitz', 'router' )

ENV['RIBITZ_ENV'] ||= 'development'

require 'ribitz'
