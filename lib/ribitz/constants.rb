module Ribitz

  ############################################
  # Message Types
  # 
  # Ribitz uses mulitpart string messages, first
  # part of the message defines what comes after
  # 
  #############################################
  # reserved for messages to control application
  CONTROL = 'control'
  # special message type, type is stripped and
  # the rest of the message is sent along
  FORWARD = 'forward'
  # test message, payload follows
  TEST = 'test'
  ##########################################
  # Type field for control messages, type
  # field is the second element of a multi
  # part message
  ##########################################
  SHUTDOWN = 'shutdown'
end
