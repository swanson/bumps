from twisted.internet.protocol import Protocol, Factory
from twisted.internet import reactor
from MySQLdb import *
from getpass import *
import ConfigParser
from twisted.protocols.basic import LineReceiver
from DatabaseServiceProvider import DatabaseServiceProvider

class TCPLoggingServer(LineReceiver):

    def connectionMade(self):
        print "connection established"
        self.transport.write("connectionMade\r\n")

    def connectionLost(self, reason):
        print "lost a connection", reason

    def lineReceived(self, line):
        print "received: ",line
        self.factory.dsp.logToDatabase(line)

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
        self.dsp = DatabaseServiceProvider(self.db)

reactor.listenTCP(8005, TCPLoggingFactory())
reactor.run()


