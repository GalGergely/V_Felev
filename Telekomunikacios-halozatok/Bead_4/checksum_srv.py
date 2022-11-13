from socket import socket, AF_INET, SOCK_STREAM, SOL_SOCKET, SO_REUSEADDR
import sys
from select import select
import sys
import datetime

if (len(sys.argv)==1):
    server_addr = ("localhost", 11000)
elif(len(sys.argv)==3):
    server_addr = (sys.argv[1], int(sys.argv[2]))
else:
    exit(1)
    
with socket(AF_INET, SOCK_STREAM) as server:
    server.bind(server_addr)
    server.listen(2)

    socketek = [server]
    checksums = set()

    while True:
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
                data = s.recv(128)
                # ha 0 byte akkor kilepett a kliens
                if not data:
                    socketek.remove(s)
                    s.close()
                    print("Kilepett")
                else:
                    data2 = data.decode().split("|")
                    if data2[0] == "BE":
                        data2 = data2 + [datetime.datetime.now()]
                        checksums.add(tuple(data2))
                    else:
                        found = False
                        for checksum in checksums:
                            if checksum[5] + datetime.timedelta(0,int(checksum[2])) > datetime.datetime.now():
                                if checksum[1] == data2[1]:
                                    found = True
                                    checksumdata = checksum[3] + "|" + checksum[4]
                                    s.sendall(checksumdata.encode())
                        if not found:
                            checksumdata = "0|"
                            s.sendall(checksumdata.encode())
                        newChecksums = []
                        for checksum in checksums:
                            if checksum[5] + datetime.timedelta(0,int(checksum[2])) < datetime.datetime.now():
                                newChecksums.add(checksum)
                        checksums = newChecksums