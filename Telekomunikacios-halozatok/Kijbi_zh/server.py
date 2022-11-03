from socket import socket, AF_INET, SOCK_STREAM, timeout, SOL_SOCKET, SO_REUSEADDR
import struct
import sys
import random
from select import select

server_addr = ('localhost', 10000)

packer = struct.Struct('i1s')
taller=20
garas=50
mitmondtal = True

def openClient(ret):
    unpacker = struct.Struct('20s')
    packer = struct.Struct('i')
    from socket import socket, AF_INET, SOCK_DGRAM
    server_address = ('localhost',11000)
    with socket(AF_INET, SOCK_DGRAM) as client:
        client.sendto(packer.pack(ret),server_address)
        data, _ = client.recvfrom(unpacker.size)
        returnvalue=unpacker.unpack(data)
        return returnvalue[0].decode().strip('\x00')

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
                data = s.recv(packer.size)
                # ha 0 byte akkor kilepett a kliens
                if not data:
                    socketek.remove(s)
                    s.close()
                    print("Kilepett")
                else:
                    unp_data = packer.unpack(data)
                    if(unp_data[0] > 140):
                        print('kuldtem', '?')
                        s.sendall(packer.pack(0,'?'.encode()))
                    else:
                        if unp_data[1].decode() == 'T':
                            ret=int(unp_data[0])*taller+random.randint(0,1)
                        else:
                            ret=int(unp_data[0])*garas+random.randint(0,1)
                        ellenorzott=openClient(ret)
                        if ellenorzott == 'CORRUPTED':
                            print('kuldtem', 'CORRUPTED')
                            s.sendall(packer.pack(ret,'C'.encode()))
                        if ellenorzott == 'OK':
                            print('kuldtem', ret)
                            s.sendall(packer.pack(ret,'D'.encode()))
                        
                        