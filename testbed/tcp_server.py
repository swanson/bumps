from twisted.internet.protocol import Protocol, Factory
from twisted.internet import reactor
from MySQLdb import *
from getpass import *

class TCPLoggingServer(Protocol):
    
    def connectionMade(self):
        self.transport.write("connectionMade\r\n") 

    def connectionLost(self, reason):
        print "lost a connection", reason

    def dataReceived(self, line):
        print line,
        #self.transport.write("server:" + line)
        logToDatabase(line)

    def logToDatabase(self, datagram):
        data = datagram.split(':')
        if len(data) < 3:
            print "Bad data: %s" % datagram
            return
        print "add %s entry for %s, value: %s" % (data[0], data[1], data[2])
        query = """insert into `data` values (NULL,"%s","%s","%s",NOW(),NOW())""" %(data[0],data[1],data[2])
        self.factory.cursor.execute(query)


class TCPLoggingFactory(Factory):
    protocol = TCPLoggingServer

    def __init__(self):
        print "starting server"
        try:
            pw = getpass()
            self.db = connect(host="localhost",user="iphone_S10",passwd=pw, \
                                db="iphone_obd2",port=3306, connect_timeout=5)
        except OperationalError:
            print "Error!"
            return
        print self.db
        self.cursor = self.db.cursor()

reactor.listenTCP(8005, TCPLoggingFactory())
reactor.run()


