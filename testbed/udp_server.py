from twisted.internet.protocol import DatagramProtocol
from twisted.internet import reactor
from MySQLdb import *
from getpass import *

class SimpleUDPServer(DatagramProtocol):
    def startProtocol(self):
        print "Starting server..."
        try:
            pw = getpass()
            self.db = connect(host="localhost",user="iphone_S10",passwd=pw, \
                                db="iphone_obd2",port=3306, connect_timeout=5)
        except OperationalError:
            print "Error!"
            return
        print self.db
        self.cursor = self.db.cursor()

    def datagramReceived(self, datagram, address):
        print "Received:" + repr(datagram)
        self.transport.write("data received %s" %repr(datagram), address)
        self.logToDatabase(datagram) 

    def logToDatabase(self, datagram):
        data = datagram.split(':')
        if len(data) < 3:
            print "Bad data: %s" % datagram
            return
        print "add %s entry for %s, value: %s" % (data[0], data[1], data[2])

reactor.listenUDP(8005, SimpleUDPServer())
reactor.run()
