from socket import socket, AF_INET, SOCK_DGRAM
from dataclasses import dataclass


@dataclass
class Data:
    x: float
    y: float
    operator: str


server_addr = ('', 10000)

with socket(AF_INET, SOCK_DGRAM) as server:
    server.bind(server_addr)

    data, client_address = server.recvfrom(200)
    d = data.decode()
    print("Kaptam: ", d[0], "Tole: ", client_address)

    server.sendto("Hello kliens".encode(), client_address)
