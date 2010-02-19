from socket import *
import sys

host, port = ('128.46.96.170', 8005)

server = socket(AF_INET, SOCK_DGRAM)
server.connect((host,port))
print 'starting'
while 1:
    try:
        msg = sys.stdin.readline()
        server.send(msg)
        data = server.recv(1024)
        print 'received', repr(data)
    except KeyboardInterrupt:
        server.close()
        sys.exit()
    except error:
        print 'lost connection'
        sys.exit()
        #try to reconnect
