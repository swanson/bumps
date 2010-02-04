from socket import *
import sys

host, port = ('', 50001)
server = socket(AF_INET,SOCK_STREAM)
server.bind((host,port))
server.listen(1)
conn, addr = server.accept()
print 'Connected by', addr
while 1:
    try:
        data = conn.recv(1024)
        if data:
            print 'received ', repr(data)
            conn.send(data)
    except KeyboardInterrupt:
        conn.close()
        print 'closing socket'
        sys.exit()
