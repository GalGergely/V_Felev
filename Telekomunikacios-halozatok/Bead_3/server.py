from random import gammavariate
from socket import socket, AF_INET, SOCK_STREAM, timeout, SOL_SOCKET, SO_REUSEADDR
import struct
from select import select
from random import *
import sys

if (len(sys.argv) < 3 or len(sys.argv) > 4):
    exit(1)

server_addr = (sys.argv[1], int(sys.argv[2]))
unpacker = struct.Struct('1si')  # char[1], int,
#num = randint(1, 100)
num = 55
gameOn = True

with socket(AF_INET, SOCK_STREAM) as server:
    server.bind(server_addr)
    server.listen(1)
    server.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)

    socketek = [server]

    while True:
        r, w, e = select(socketek, [], [], 1)

        if not (r or w or e):
            continue

        for s in r:
            if s is server:
                # kliens csatlakozik
                client, client_addr = s.accept()
                socketek.append(client)
                print("Csatlakozott", client_addr)
            else:
                data = s.recv(unpacker.size)
                # ha 0 byte akkor kilepett a kliens
                if not data:
                    socketek.remove(s)
                    s.close()
                    print("Kilepett")
                else:
                    unp_data = unpacker.unpack(data)
                    print("Unpack:", unp_data)
                    if (gameOn):
                        if (unp_data[0].decode() == '<'):
                            if (unp_data[1] > num):
                                packed_data = unpacker.pack("I".encode(), 0)
                                s.sendall(packed_data)
                            else:
                                packed_data = unpacker.pack("N".encode(), 0)
                                s.sendall(packed_data)
                        elif (unp_data[0].decode() == '>'):
                            if (unp_data[1] < num):
                                packed_data = unpacker.pack("I".encode(), 0)
                                s.sendall(packed_data)
                            else:
                                packed_data = unpacker.pack("N".encode(), 0)
                                s.sendall(packed_data)
                        elif (unp_data[0].decode() == '='):
                            if (unp_data[1] == num):
                                packed_data = unpacker.pack("Y".encode(), 0)
                                s.sendall(packed_data)
                                gameOn = False
                            else:
                                packed_data = unpacker.pack("K".encode(), 0)
                                s.sendall(packed_data)
                    else:
                        packed_data = unpacker.pack("V".encode(), 0)
                        s.sendall(packed_data)
