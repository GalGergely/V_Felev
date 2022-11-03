from socket import socket, AF_INET, SOCK_DGRAM
import random

server_address = ('localhost',11000)

with socket(AF_INET, SOCK_DGRAM) as server:
    server.bind(server_address)
    data, client_addr = server.recvfrom(200)
    print("Kaptam:",data.decode(),"tole:",client_addr)
    x=random.randint(1,10)
    ret='feladat'+str(x)
    print('atadva:',ret)
    server.sendto(ret.encode(),client_addr)