from socket import socket, AF_INET, SOCK_STREAM, timeout, SOL_SOCKET, SO_REUSEADDR
import struct
import sys
import random
import json
import time

if (len(sys.argv)!=3):
    exit(1)

server_addr = ('localhost', 10000)
packer = struct.Struct('i1s')

allas=json.load(open(sys.argv[2]))
penznem=sys.argv[1]

with socket(AF_INET, SOCK_STREAM) as client:
    client.connect(server_addr)
    for a in allas.values():
        packed_data = packer.pack(a,penznem.encode())
        client.sendall(packed_data)

        data = client.recv(packer.size)
        unp_data = packer.unpack(data)
        if(unp_data[1].decode()=='D'):
            print("fizetendo: ", unp_data[0])
        time.sleep(random.randint(1,5))

