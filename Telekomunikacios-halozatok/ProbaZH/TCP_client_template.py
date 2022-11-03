from socket import socket, AF_INET, SOCK_STREAM, timeout, SOL_SOCKET, SO_REUSEADDR
import struct
import sys

if (len(sys.argv)!=3):
    exit(1)

server_addr = (sys.argv[1], int(sys.argv[2]))
packer = struct.Struct('25s')  # int, int, char[1]

with socket(AF_INET, SOCK_STREAM) as client:
    client.connect(server_addr)
    while True:

        packed_data = packer.pack('Kerek feladatot'.encode())
        client.sendall(packed_data)

        data = client.recv(packer.size)
        unp_data = packer.unpack(data)
        ret = unp_data[0].decode()
        print(ret)
        if (ret.strip('\x00') != 'Nincs kesz'):
            
            packed_data = packer.pack('Koszonom'.encode())
            client.sendall(packed_data)
            data = client.recv(packer.size)
            unp_data = packer.unpack(data)
            ret = unp_data[0].decode()
            break
