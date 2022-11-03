from socket import socket, AF_INET, SOCK_STREAM, timeout, SOL_SOCKET, SO_REUSEADDR
import struct
import sys
from select import select

if (len(sys.argv) !=4):
    exit(1)

server_addr = (sys.argv[1], int(sys.argv[2]))

packer = struct.Struct('25s')
idiots = 0
tureshatar = int(sys.argv[3])

def openClient(ret):
    from socket import socket, AF_INET, SOCK_DGRAM
    server_address = ('localhost',11000)
    with socket(AF_INET, SOCK_DGRAM) as client:
        client.sendto(ret.encode(),server_address)
        data, _ = client.recvfrom(200)
        return data.decode()

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
                    res = unp_data[0].decode()
                    if (res.strip('\x00') == 'Kerek feladatot'):
                        print('kaptam : ','Kerek feladatot')
                        if (idiots < tureshatar):
                            idiots = idiots+1
                            s.sendall(packer.pack('Nincs kesz'.encode()))
                            print('kuldtem: ','Nincs kesz')
                        else:
                            ret=openClient('Keres')
                            atad='Itt a feladat: '+ret
                            print(atad)
                            s.sendall(packer.pack(atad.encode()))
                            print('kuldtem: ','Itt a feladat')
                    elif ((res.strip('\x00') == 'Koszonom')):
                        print('kaptam : ','Koszonom')
                        print('kuldtem: ','Szivesen')
                        s.sendall(packer.pack('Szivesen'.encode()))

