import struct
import sys
import socket

if(len(sys.argv) == 3) :
    packer = struct.Struct("20si")
    with open("domainPort.bin", "rb") as f:
        f.seek(packer.size*int(sys.argv[2]))
        asd = f.read(packer.size)
        row = packer.unpack(asd)
if(sys.argv[1]=='domain'):
    name = row[0].decode().strip('\x00')
    print(name)
    print(socket.gethostbyname(name))
elif(sys.argv[1]=='port'):
    port = row[1]
    print(port)
    print(socket.getservbyport(port))