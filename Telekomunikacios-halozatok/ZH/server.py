from socket import socket, AF_INET, SOCK_STREAM, timeout, SOL_SOCKET, SO_REUSEADDR
import struct
import sys
from select import select

server_addr = ('localhost', 10000)

packer = struct.Struct('3s10sf')
packer2 = struct.Struct('3s')
topic = {}
subbs = {}


def notifySubbs(key, value):
    print('valtoztatas kezbesitve:', key, value)
    for s in subbs:
        if (key == s):
            for server_adresses in subbs[s]:
                print(server_adresses[0])
                from socket import socket, AF_INET, SOCK_DGRAM
                server_address = (server_adresses[0], 11000)
                with socket(AF_INET, SOCK_DGRAM) as client:
                    client.sendto(packer.pack('REG'.encode(),
                                  str(key).encode(), float(value)), server_address)
                    data, _ = client.recvfrom(packer.size)
                    print('A feliratkozo visszajelzett, hogy megkapta az uzenetet')


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
                    print(unp_data[0].decode().strip('\x00'))
                    if (unp_data[0].decode().strip('\x00') == 'IN'):
                        topic[unp_data[1].decode().strip('\x00')] = unp_data[2]
                        print('Elmentve', unp_data[1].decode().strip(
                            '\x00'), unp_data[2])
                        s.sendall(packer2.pack('ACK'.encode()))
                        notifySubbs(unp_data[1].decode().strip(
                            '\x00'), unp_data[2])
                    elif (unp_data[0].decode().strip('\x00') == 'OUT'):
                        res = False
                        xd = None
                        for t in topic:
                            if (t == unp_data[1].decode().strip('\x00')):
                                res = True
                                xd = t
                        if (res):
                            print('Megtalalva: ', topic[xd])
                            s.sendall(packer2.pack(str(topic[xd])))
                        else:
                            print('Nem volt benne')
                            s.sendall(packer2.pack(str(-9999)))
                    elif (unp_data[0].decode().strip('\x00') == 'REG'):
                        res = False
                        for s in subbs:
                            if (unp_data[1].decode().strip('\x00') == s):
                                res = True
                                subbs[unp_data[1].decode().strip(
                                    '\x00')].append(client_addr)
                        if (res == False):
                            subbs[unp_data[1].decode().strip('\x00')] = []
                            subbs[unp_data[1].decode().strip(
                                '\x00')].append(client_addr)
                        print(subbs)
