extern "C" {
    #include "ipasir.h"
}

#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <vector>

int main(int argc, char **argv) {
	std::cout << "c Using the incremental SAT solver " << ipasir_signature() << std::endl;
    void* solver = ipasir_init();

    int vars = 5;

    // minimally one literal is true
    for (int i = 1; i <= vars; i++) {
        ipasir_add(solver, i);
    }
    ipasir_add(solver, 0);

    // maximally one literal is true (trivial encoding)
    // for (int i = 1; i <= vars; i++) {
    //     for (int j = i+1; j <= vars; j++) {
    //         ipasir_add(solver, -i);
    //         ipasir_add(solver, -j);
    //         ipasir_add(solver, 0);
    //     }
    // }

    // maximally one literal is true (sequential counter / optimized ladder encoding)
    // s_0 -> s_1 -> s_2 -> ... -> s_n
    // (-s_0 or s_1) and (-s_1 or s_2) ...
    // s_0 = 0; s_n = 1; -s_0; s_n;
    // X_i -> s_i (-X_i or s_i)
    // X_i -> -s_(i-1)

    for (int i = 1; i < vars; i++) {
        ipasir_add(solver, -1 * (vars + i));
        ipasir_add(solver, vars + i + 1);
        ipasir_add(solver, 0);
    }

    for (int i = 1; i <= vars; i++) {
        ipasir_add(solver, -1 * i);
        ipasir_add(solver, vars + i);
        ipasir_add(solver, 0);
    }

    for (int i = 2; i <= vars; i++) {
        ipasir_add(solver, -1 * i);
        ipasir_add(solver, -1 * (vars + i - 1));
        ipasir_add(solver, 0);
    }
    
    ipasir_add(solver, 2 * vars);
    ipasir_add(solver, 0);

    int result = 0;    
    while (result != 20) {
        result = ipasir_solve(solver);
        if (result == 10) {
            std::cout << "s SATISFIABLE" << std::endl;
            std::cout << "v ";
            std::vector<int> sol;
            for (int i = 1; i <= vars; i++) {
                int val = ipasir_val(solver, i);
                sol.push_back(val);
                std::cout << val << " ";
            }
            std::cout << std::endl;

            for (int val : sol) {
                ipasir_add(solver, -1 * val); 
            }
            ipasir_add(solver, 0);
        }
        else if (result == 20) {
            std::cout << "s UNSATISFIABLE" << std::endl;
        }
        else {
            std::cout << "s UNKNOWN" << std::endl;
        }
    }
}