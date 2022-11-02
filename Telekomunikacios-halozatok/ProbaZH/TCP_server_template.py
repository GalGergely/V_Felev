from socket import socket, AF_INET, SOCK_STREAM, timeout, SOL_SOCKET, SO_REUSEADDR
import struct
from select import select

server_addr = ('', 10000)
packer = struct.Struct('20s')
idiots = 0
tureshatar = 5

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
                        if (idiots < tureshatar):
                            idiots = idiots+1
                            s.sendall(packer.pack('Nincs kesz'.encode()))
                        else:
                            s.sendall(packer.pack('Itt a feladat'.encode()))
                    elif ((res.strip('\x00') == 'Koszonom')):
                        s.sendall(packer.pack('Szivesen'.encode()))
