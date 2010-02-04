from socket import *
import sys

host, port = ('localhost', 50001)

server = socket(AF_INET, SOCK_STREAM)
server.connect((host,port))
while 1:
    try:
        msg = sys.stdin.readline()
        server.send(msg)
        data = server.recv(1024)
        print 'received', repr(data)
    except KeyboardInterrupt:
        server.close()
        sys.exit()
