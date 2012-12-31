require File.join( File.dirname(__FILE__), %w[spec_helper] )

include Ribitz

describe Listener do
  before(:all) do
    @context = ZMQ::Context.create
  end

  it "should listen for and publish messages" do

    Thread.new { Publisher.run( @context, publisher_binding: 'tcp://*:10003' ) }

    sleep 2
    Publisher.new( @context ) do | pub |
      Thread.new { Listener.run( @context, 
                                 listener_binding: 'inproc://listener_test',
                                 forward_handler: 'inproc://publisher' ) }

      sleep 2
      publish_listen = @context.socket( ZMQ::SUB )
      publish_listen.connect( 'tcp://localhost:10003' )

      publish_listen.setsockopt(ZMQ::SUBSCRIBE, "" )

      Listener.new( @context ) do | listener |

        listener.send( FORWARD, TEST, "test message" )
        listener.send( CONTROL, SHUTDOWN )
        response = []
        publish_listen.recv_strings( response )
        ZMQ::Socket.close( publish_listen )

        response.first.should eq TEST
        response.last.should eq "test message" 
      end
      pub.send( CONTROL, SHUTDOWN )
    end
    
  end

  after(:all) do
    ZMQ::Context.close( @context )
  end
end
