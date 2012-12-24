module Ribitz
class Publisher
  def initialize( opts = {} )
    @socktype = opts.fetch( :zmq_socket_type )
    @context = opts.fetch( :zmq_context )
    @inproc_binding = opts.fetch( :inproc_binding, "inproc://#{self.__id__}" )
    @publish_binding = opts.fetch( :publish_binding )
  end

  def send( message )
  end

  

end

end
