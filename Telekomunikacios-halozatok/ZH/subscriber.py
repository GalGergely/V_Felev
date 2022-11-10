
from socket import socket, AF_INET, SOCK_DGRAM
from socket import socket, AF_INET, SOCK_STREAM, timeout, SOL_SOCKET, SO_REUSEADDR
import struct
import sys
import json

server_addr = ('localhost', 10000)
packer = struct.Struct('3s10sf')

with socket(AF_INET, SOCK_STREAM) as client:
    client.connect(server_addr)
    packed_data = packer.pack('REG'.encode(), 'homero1'.encode(), 0)
    client.sendall(packed_data)

server_address = ('localhost', 11000)

with socket(AF_INET, SOCK_DGRAM) as server:
    server.bind(server_address)
    while True:
        data, client_addr = server.recvfrom(packer.size)
        ret = packer.unpack(data)
        print("Kaptam:", ret[2], "tole:", client_addr)
        server.sendto(packer.pack('ACK'.encode(),
                      'x'.encode(), 0), client_addr)
