from socket import socket, AF_INET, SOCK_STREAM, timeout, SOL_SOCKET, SO_REUSEADDR
import struct
import time
import math
import sys

if (len(sys.argv) < 3 or len(sys.argv) > 4):
    exit(1)

server_addr = (sys.argv[1], int(sys.argv[2]))
packer = struct.Struct('1si')


def decideWhatToSend(Op, num, range, curData):
    # nagyobb ág
    if (curData == 'I' and Op == '>'):
        range[0] = num+1
        Op = '>'
    elif (curData == 'N' and Op == '>'):
        range[1] = num
        Op = '<'
    elif (curData == 'I' and Op == '<'):
        range[1] = num-1
        Op = '<'
    elif (curData == 'N' and Op == '<'):
        range[0] = num
        Op = '>'
    return Op


with socket(AF_INET, SOCK_STREAM) as client:
    client.connect(server_addr)
    Op = '<'
    curData = ''
    num = 50
    range = [1, 100]
    while (True):
        if (range[0] == range[1]):
            Op = '='
        values = (Op.encode(), int(num))
        packed_data = packer.pack(*values)
        # packed_data = packer.pack(int(szam1), int(szam2), op.encode())   # ua mint az elozo sor
        client.sendall(packed_data)
        data = client.recv(100)
        unp_data = packer.unpack(data)
        if (unp_data[0].decode() == 'V'):
            print('Vege a jateknak')
            break
        if (unp_data[0].decode() == 'Y'):
            print('Nyertel')
            break
        if (unp_data[0].decode() == 'K'):
            print('Kiestel')
            break
        print("Eredmeny:", unp_data)
        curData = unp_data[0].decode()
        Op = decideWhatToSend(Op, num, range, curData)
        num = range[0]+round((range[1]-range[0])/2)
        print('range', range)
        print('num', num)
        print('Op', Op)
