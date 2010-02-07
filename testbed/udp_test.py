from socket import *
bufsize = 1024 # Modify to suit your needs
listenPort = 8005

def listen(host, port):
    listenSocket = socket(AF_INET, SOCK_DGRAM)
    listenSocket.bind((host, port))
    while True:
        data, addr = listenSocket.recvfrom(bufsize)
        print "Received: %s from %s" % (repr(data), addr)

listen("localhost", listenPort)

