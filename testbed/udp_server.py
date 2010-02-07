from twisted.internet.protocol import DatagramProtocol
from twisted.internet import reactor

class SimpleUDPServer(DatagramProtocol):
    def startProtocol(self):
        print "Starting server..."

    def datagramReceived(self, datagram, address):
        print "Received:" + repr(datagram)
        self.transport.write("data received %s" %repr(datagram), address)


reactor.listenUDP(8005, SimpleUDPServer())
reactor.run()
