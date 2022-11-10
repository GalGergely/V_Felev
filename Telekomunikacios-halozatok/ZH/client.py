from socket import socket, AF_INET, SOCK_STREAM, timeout, SOL_SOCKET, SO_REUSEADDR
import struct
import sys
import json

server_addr = ('localhost', 10000)
packer = struct.Struct('3s10sf')
unpacker = struct.Struct('3s')
if (len(sys.argv) != 2):
    exit(1)

data = json.load(open(sys.argv[1]))

with socket(AF_INET, SOCK_STREAM) as client:
    client.connect(server_addr)
    for d in data.values():
        print(d)
        packed_data = packer.pack(d[0].encode(), d[1].encode(), d[2])
        client.sendall(packed_data)

        data = client.recv(unpacker.size)
        unp_data = unpacker.unpack(data)
        print(unp_data)
