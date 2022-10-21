import struct

var = struct.pack('if?', 1, 2.22, True)
print(var)
print(struct.unpack('if?', var))
with open('db1.bin', 'wb') as file:
    file.write(var)

var = struct.pack('?c9s', True, "a".encode(), "abcdefghi".encode())
print(var)
print(struct.unpack('?c9s', var))
with open('db2.bin', 'wb') as file:
    file.write(var)

var = struct.pack('9sfi', "abcdefghi".encode(), 2.22, 1)
print(var)
print(struct.unpack('9sfi', var))
with open('db3.bin', 'wb') as file:
    file.write(var)

var = struct.pack('?ic',  False, 2, "a".encode())
print(var)
print(struct.unpack('?ic', var))
with open('db4.bin', 'wb') as file:
    file.write(var)
