#!/usr/bin/env python3
import sys
try:
    # Pretty progress bars
    from tqdm import trange
except ImportError:
    trange = range

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} filename > outfile")
    sys.exit(1)

with open(sys.argv[1]) as f:
    n = int(f.readline())
    data = [[int(y) for y in x.strip().split(" ")] for x in f.readlines()]
dim = n*n

def var(x, y, v):
    assert 0 <= x and x <= dim-1
    assert 0 <= y and y <= dim-1
    assert 0 <= v and v <= dim-1
    return x*dim+y*dim*dim+v+1

def clause(varz):
    return " ".join([str(x) for x in varz]) + " 0"


print("c every field can be 1-n")
eprint("Encoding field value")
for y in trange(dim):
    for x in range(dim):
        if data[x][y] != 0:
            print(clause([var(x,y, data[x][y]-1)]))
        else:
            print(clause([var(x,y,v) for v in range(dim)]))

#print("c every field can only be one")
#eprint("Encoding field uniqueness...")
#for y in range(dim):
#    for x in range(dim):
#        for v1 in range(dim-1):
#            for v2 in range(v1+1,dim):
#                print(clause([-var(x,y,v1), -var(x,y,v2)]))

print("c every row each number only once")
eprint("Encoding row uniqueness...")
for y in trange(dim):
    for x1 in range(dim-1):
        for x2 in range(x1+1, dim):
            for v in range(dim):
                print(clause([-var(x1,y,v), -var(x2,y,v)]))

print("c every col each number only once")
eprint("Encoding col uniqueness...")
for y1 in trange(dim-1):
    for y2 in range(y1+1,dim):
        for x in range(dim):
            for v in range(dim):
                print(clause([-var(x,y1,v), -var(x,y2,v)]))


print("c every block each number only once")
eprint("Encoding block uniqueness...")
for x1 in trange(n):
    for y1 in range(n-1):
        for y2 in range(y1+1, n):
            for x2 in range(n):
                if x1 == x2:
                    continue
                for yb in range(n):
                    for xb in range(n):
                        for v in range(dim):
                            print(clause([
                                -var(xb*n+x1,yb*n+y1,v), 
                                -var(xb*n+x2,yb*n+y2,v)
                            ]))

#print("c all given assigments have to hold")
#eprint("Encoding given assignments...")
#for x in trange(dim):
#    for y in range(dim):
#        v = data[x][y]
#        if v != 0:
#            print(clause([var(x,y,v-1)]))
