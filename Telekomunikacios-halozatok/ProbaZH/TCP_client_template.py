from socket import socket, AF_INET, SOCK_STREAM, timeout, SOL_SOCKET, SO_REUSEADDR
import struct

server_addr = ('localhost', 10000)
packer = struct.Struct('20s')  # int, int, char[1]

with socket(AF_INET, SOCK_STREAM) as client:
    client.connect(server_addr)
    while True:

        packed_data = packer.pack('Kerek feladatot'.encode())
        client.sendall(packed_data)

        data = client.recv(packer.size)
        unp_data = packer.unpack(data)
        ret = unp_data[0].decode()

        if (ret.strip('\x00') == 'Itt a feladat'):
            packed_data = packer.pack('Koszonom'.encode())
            client.sendall(packed_data)
            data = client.recv(packer.size)
            unp_data = packer.unpack(data)
            ret = unp_data[0].decode()
            print(ret)
            break
