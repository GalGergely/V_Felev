from socket import socket, AF_INET, SOCK_DGRAM
from dataclasses import dataclass


@dataclass
class Data:
    x: float
    y: float
    operator: str


server_addr = ('localhost', 10000)
with socket(AF_INET, SOCK_DGRAM) as client:
    d = Data(2, 2, '+')
    client.sendto(d.encode('iic', 4, 4, 1), server_addr)

    data, _ = client.recvfrom(200)

    print("Kaptam: ", data.decode())
