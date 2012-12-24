$: << File.join( Dir.pwd, 'lib' )

ENV['RIBITZ_ENV'] ||= 'development'

require 'ribitz'
