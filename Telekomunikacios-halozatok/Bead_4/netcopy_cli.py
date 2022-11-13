from socket import socket, AF_INET, SOCK_STREAM

import sys
import zlib

server_addr = ("localhost", 10000)
checksum_addr = ('localhost',11000)
file_id = '2'
file_path = 'C:\V_Felev\Telekomunikacios-halozatok\Bead_4\input.txt'

if (len(sys.argv)==1):
    server_addr = ("localhost", 10000)
elif(len(sys.argv)==7):
    server_addr = (sys.argv[1], int(sys.argv[2]))
    checksum_addr = (sys.argv[3], int(sys.argv[4]))
    file_id = sys.argv[5]
    file_path = sys.argv[6]
else:
    exit(1)

with socket(AF_INET, SOCK_STREAM) as client:
    client.connect(server_addr)
    data = bytearray()
    with open(file_path) as f:
        line = f.readline()
        while line != "":
            encodedLine = line.encode()
            client.sendall(encodedLine)
            data += encodedLine
            line = f.readline()
    hash = zlib.crc32(data)
    csData = bytearray()
    csData += ("BE|" + file_id + "|60|" + str(len(str(hash))) + "|").encode()
    csData += hex(hash).encode()
    with socket(AF_INET, SOCK_STREAM) as checksum_sock:
        checksum_sock.connect(checksum_addr)
        checksum_sock.sendall(csData)