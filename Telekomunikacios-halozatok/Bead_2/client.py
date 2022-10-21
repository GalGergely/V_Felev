# - Parameter1 formatuma: integer, float, bool
# - Parameter2 formatuma: bool, karakter, 9 hosszú string
# - Parameter3 formatuma: 9 hosszú string, float, integer
# - Parameter4 formatuma: bool, integer, karakter
import sys
import struct

packer = []
packer.append(struct.Struct('if?'))
packer.append(struct.Struct('?c9s'))
packer.append(struct.Struct('9sfi'))
packer.append(struct.Struct('?ic'))

files = []
if (len(sys.argv) < 2):
    exit(1)
else:
    for i in range(0, len(sys.argv)-1):
        files.append(sys.argv[i+1])

for i in range(0, len(files)):
    with open(files[i], 'rb') as f:
        data = f.read(packer[i].size)
        p = packer[i]
        adat = p.unpack(data)
        out = []
        for a in adat:
            out.append(a)
    print(tuple(out))

packer = struct.Struct('16si?')
print(packer.pack("elso".encode(), 84, True))
packer = struct.Struct('f?c')
print(packer.pack(87.5, False, 'X'.encode()))
packer = struct.Struct('i14sf')
print(packer.pack(75, "masodik".encode(), 94.9))
packer = struct.Struct('ci17s')
print(packer.pack('Z'.encode(), 106, "harmadik".encode()))
