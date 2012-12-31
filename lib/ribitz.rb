require 'ffi-rzmq'
require 'yaml'

ENV['RIBITZ_ENV'] ||= 'development'
APP_CONFIG=YAML.load_file('config/router.yaml')[ENV['RIBITZ_ENV']]

require 'ribitz/constants'
require 'ribitz/logger'
require 'ribitz/publisher'
require 'ribitz/listener'
