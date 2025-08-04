import sys

from Tetris import Tetris

def main():
	t = Tetris(sys.argv[2], sys.argv[1], sys.argv[3], sys.argv[4], sys.argv[6], sys.argv[5], sys.argv[7])
	t.encode()

if __name__=="__main__":
	main()