from twisted.internet.protocol import DatagramProtocol
from twisted.internet import reactor
from MySQLdb import *
from getpass import *

class SimpleUDPServer(DatagramProtocol):
    def startProtocol(self):
        print "Starting server..."
        try:
            pw = getpass()
            db = connect(host="localhost",user="mdswanso",passwd=pw, \
                                db="iphone_obd2",port=3306, connect_timeout=5)
        except OperationalError:
            return None
        return db


    def datagramReceived(self, datagram, address):
        print "Received:" + repr(datagram)
        self.transport.write("data received %s" %repr(datagram), address)


reactor.listenUDP(8005, SimpleUDPServer())
reactor.run()
