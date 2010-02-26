from twisted.internet.protocol import Protocol, Factory
from twisted.internet import reactor
from MySQLdb import *
from getpass import *
import ConfigParser
from twisted.protocols.basic import LineReceiver

class TCPLoggingServer(LineReceiver):
    
    def connectionMade(self):
        self.transport.write("connectionMade\r\n") 

    def connectionLost(self, reason):
        print "lost a connection", reason

    def lineReceived(self, line):
        print line,
        #self.transport.write("server:" + line)
        self.logToDatabase(line)

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
            config = ConfigParser.ConfigParser()
            config.read("db.conf")
            pw = config.get("database", "passwd")
            hostname = config.get("database", "host")
            usr = config.get("database", "user")
            dbn = config.get("database", "db")
            p = config.get("database", "port")
            timeout = config.get("database", "timeout")
            self.db = connect(host=hostname,user=usr,passwd=pw, \
                                db=dbn,port=int(p), connect_timeout=int(timeout))
        except OperationalError:
            print "Error!"
            return
        print self.db
        self.cursor = self.db.cursor()

reactor.listenTCP(8005, TCPLoggingFactory())
reactor.run()


