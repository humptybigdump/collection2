import sys

from Nonogram import Nonogram

def main():
	n = Nonogram(sys.argv[1])
	n.encode()

if __name__=="__main__":
	main()