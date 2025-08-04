extern "C" {
    #include "ipasir.h"
}

#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <vector>

/**
 * Reads a formula from a given file 
 */
bool loadFormula(void* solver, const char* filename, int* outVariables) {
	FILE* f = fopen(filename, "r");

	if (f == NULL) {
		return false;
	}

	int maxVar = 0;
	int c = 0;
	bool neg = false;	
	while (c != EOF) {
		c = fgetc(f);

		if (c == 'c' || c == 'p') { // skip comments and header
			while(c != '\n') c = fgetc(f);
			continue;
		}
		
		if (isspace(c)) continue; // skip whitespace
		
		if (c == '-') { // negative number coming
			neg = true;
			continue;
		}

		// number
		if (isdigit(c)) {
			int num = c - '0';
			c = fgetc(f);
			while (isdigit(c)) {
				num = num*10 + (c-'0');
				c = fgetc(f);
			}
			if (neg) {
				num *= -1;
			}
			neg = false;

			if (abs(num) > maxVar) {
				maxVar = abs(num);
			}
			// add to the solver
			ipasir_add(solver, num);
		}
	}

	fclose(f);
	*outVariables = maxVar;
	return true;
}

int main(int argc, char **argv) {
	std::cout << "c Using the incremental SAT solver " << ipasir_signature() << std::endl;
    void* solver = ipasir_init();

    int vars = 0;
    loadFormula(solver, argv[1], &vars);
    int result = ipasir_solve(solver);
    if (result == 10) {
        std::cout << "s SATISFIABLE" << std::endl;
    }
    else if (result == 20) {
        std::cout << "s UNSATISFIABLE" << std::endl;
    }
    else {
        std::cout << "s UNKNOWN" << std::endl;
    }
}