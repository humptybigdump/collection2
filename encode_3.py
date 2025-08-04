import sys
from Hidoku import Hidoku

if len(sys.argv) < 2:
	print("Hidoku.py [hidoku game]")
h = Hidoku(sys.argv[1])
h.encode()