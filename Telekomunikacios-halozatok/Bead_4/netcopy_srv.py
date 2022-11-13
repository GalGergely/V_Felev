from socket import socket, AF_INET, SOCK_STREAM, SOL_SOCKET, SO_REUSEADDR
from select import select
from random import *
import sys
import zlib

server_addr = ("localhost", 10000)
checksum_addr = ('localhost',11000)
file_id = '2'
file_path = 'C:\V_Felev\Telekomunikacios-halozatok\Bead_4\output.txt'

if (len(sys.argv)==1):
    server_addr = ("localhost", 10000)
elif(len(sys.argv)==7):
    server_addr = (sys.argv[1], int(sys.argv[2]))
    checksum_addr = (sys.argv[3], int(sys.argv[4]))
    file_id = sys.argv[5]
    file_path = sys.argv[6]
else:
    exit(1)

with socket(AF_INET, SOCK_STREAM) as server:
    server.bind(server_addr)
    server.listen(1)
    server.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
    socketek = [server]
    data=bytearray()
    run = True
    while run:
        r, w, e = select(socketek, [], [], 1)

        if not (r or w or e):
            continue

        for s in r:
            if s is server:
                # kliens csatlakozik
                client, client_addr = s.accept()
                socketek.append(client)
                print("Csatlakozott", client_addr)
            else:
                part = s.recv(16)
                if not part:
                    socketek.remove(s)
                    s.close()
                    print("Kilepett")
                    run=False
                    break
                data.extend(part)
                
with open(file_path, "w") as f:
    f.writelines(data.decode())

checksum = zlib.crc32(data)

with socket(AF_INET, SOCK_STREAM) as csSock:
    csSock.connect(checksum_addr)
    checksum_data = ("KI|" + file_id).encode()
    
    csSock.sendall(checksum_data)
    data = csSock.recv(128)
    
    splitedData = data.decode().split("|")
    if splitedData[1] == hex(checksum) and splitedData[0] == str(len(hex(checksum))):
        print("CSUM OK")
    else:
        print("CSUM CORRUPTED")