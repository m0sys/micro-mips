#!/usr/bin/env python3
import binascii

out = []
for d in open("single_cycle_proc.srcs/sim_1/new/memfile.dat").read().strip().split("\n"):
    print(d)
    out.append(binascii.unhexlify(d)[::-1])

with open("single_cycle_proc.srcs/sim_1/new/memfile.bin", "wb") as f:
    f.write(b''.join(out))
