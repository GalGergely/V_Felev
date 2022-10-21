from socket import AF_INET, socket, SOCK_STREAM, SOCK_DGRAM
import struct
from select import select

proxy_address = ('localhost', 10000)
server_address = ('localhost', 11000)

packer = struct.Struct('iic')

with socket(AF_INET, SOCK_STREAM) as proxy, socket(AF_INET, SOCK_DGRAM) as udp_client:
    inputs = [proxy]
    proxy.bind(proxy_address)
    proxy.listen(1)
    while True:
        r, w, e = select(inputs, inputs, inputs)
        if not (r or w or e):
            continue
        for s in r:
            if s is proxy:
                client, client_address = s.accept()
                print("Connected", client_address)
                inputs.append(proxy)
            else:
                data = s.recv()
                if not data:
                    inputs.remove(s)
                    s.close()
                    print("Exited")
                else:
                    udp_client.sendto(data, server_address)
                    resp, _ = udp_client.recv(200)
                    s.sendall(resp)
