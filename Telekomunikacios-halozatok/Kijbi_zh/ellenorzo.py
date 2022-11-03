from socket import socket, AF_INET, SOCK_DGRAM
import json
import struct

server_address = ('localhost',11000)
file=json.load(open('e.json'))
packer = struct.Struct('20s')
unpacker = struct.Struct('i')

with socket(AF_INET, SOCK_DGRAM) as server:
    server.bind(server_address)
    while True:
        data, client_addr = server.recvfrom(200)
        ret = unpacker.unpack(data)
        print("Kaptam:",ret[0],"tole:",client_addr)
        print(int(ret[0])*50, int(ret[0])*20, file['measurement2'])
        if(int(ret[0])==int(file['measurement2'])*50 or int(ret[0])==int(file['measurement2'])*20):  
            print('atadva:','OK')
            server.sendto(packer.pack('OK'.encode()),client_addr)
        else:
            print('atadva:','CORRUPTED')
            server.sendto(packer.pack('CORRUPTED'.encode()),client_addr)