extern "C" {
    #include "ipasir.h"
}

#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <vector>
#include <chrono> 


bool loadSpec (const char* filename, int* outV, int* outE){
	FILE* f = fopen(filename, "r");
	if (f == NULL) return false;
	int c = 0;
	while (c != EOF) {
		c = fgetc(f);
		if (c == 'c') { // skip comments
			while(c != '\n') c = fgetc(f);
			continue;
		}
		if (c == 'p') { // get (V,E) from header
			c = fgetc(f);
			if (!isspace(c)) return false; // skip space
			c = fgetc(f); 
			while (!isspace(c)) c = fgetc(f); // skip 'edge'
			c = fgetc(f);
			int V = 0;
			int E = 0;			
			if (isdigit(c)) { // get V 
				V = c - '0';
				c = fgetc(f); 
				while (isdigit(c)) {
					V = V * 10 + (c - '0');
					c = fgetc(f); 
				}
			}
			if (!isspace(c)) return false;
			c = fgetc(f); 
			if(isdigit(c)) { // get E
				E = c - '0';
				c = fgetc(f); 
				while (isdigit(c)) {
					E = E * 10 + (c - '0');
					c = fgetc(f); 
				}
			}
			*outV = V; 
			*outE = E;
			return true;
		} else return false;
	}
	fclose(f);
	return false;
}

bool loadEdges (const char* filename,int* outE1, int* outE2, int E) {
	FILE* f = fopen(filename, "r");
	if (f == NULL) return false;
	int c = 0;
	int counter = 0;
	while (c != EOF) {
		c = fgetc(f);
		if (c == 'c' || c == 'p') { // skip comments and header
			while(c != '\n') c = fgetc(f);
			continue;
		}		
		if (c == 'e') { // get edges 
			int e1 = 0;
			int e2 = 0;
			c = fgetc(f);
			if (!isspace(c)) return false; // skip space 
			c = fgetc(f);
			if (isdigit(c)) { // get e1 
				e1 = c - '0';
				c = fgetc(f);
				while (isdigit(c)) {
					e1 = e1 * 10 + (c - '0');
					c = fgetc(f);
				}
			}
			if (!isspace(c)) return false; // skip space
			c = fgetc(f);
			if (isdigit(c)) {
				e2 = c - '0';
				c = fgetc(f);
				while (isdigit(c)) {
					e2 = e2 * 10 + (c - '0');
					c = fgetc(f);
				}
			}

		outE1[counter] = e1;
		outE2[counter] = e2;
		counter++;
		}
	}
	if (counter != E) return false;
	fclose(f);
	return true;
}

/**
 * adds all necessary 'at least' clauses together with assumptions 2 <= k <= V
 * Best Case: 2 colors 
 * Worst Case: V colors 
 **/
void initClauses (void* solver, int V, int E, int* e1, int* e2) {
	for (int k = 2; k <= V; k ++) { 
		for (int v = 1; v <= V; v++) {
			ipasir_add(solver, k); // add assumption for all colors: 2 <= k <= V
			for (int j = 0; j < k; j++) {
				ipasir_add(solver, V + v + (j * V)); // offset of V, because first V variables are reserved for assumptions
			}
			ipasir_add(solver, 0);
		}
	}
	for (int e = 0; e < E; e++) { // add 'edge' clauses with only 1 color
		ipasir_add(solver, -1 * (V + e1[e]));
		ipasir_add(solver, -1 * (V + e2[e]));
		ipasir_add(solver, 0);
	}
}

void addClauses (void* solver, int V, int E, int* e1, int* e2, int K){
	/**
	 * pairwise 'at most' clauses for K colors,
	 * assuming all 'at most' clauses for K-1 colors already exist.
	 **/
	for (int v = 1; v <= V; v++) {
		for (int k = 0; k < K - 1; k++){
			ipasir_add(solver, -1 * (V + v + k * V));
			ipasir_add(solver, -1 * (V + v + (K - 1) * V));
			ipasir_add(solver, 0);
		}
	}

	/**
	 * add all 'edge' clauses for K colors 
	 * assuming all 'at most' clauses for K-1 colors already exist.
	 **/
	for (int e = 0; e < E; e++) {
		ipasir_add(solver, -1 * (V + (e1[e] + (K - 1) * V)));
		ipasir_add(solver, -1 * (V + (e2[e] + (K - 1) * V))) ;
		ipasir_add(solver, 0);
	}
}

int main(int argc, char **argv) {
	std::cout << "c Using the incremental SAT solver " << ipasir_signature() << std::endl;

	if (argc != 2) {
		puts("c USAGE: ./example <dimacs.col>");
		return 0;
	}
	int E = 0;
	int V = 0;
	bool loadedspec = loadSpec(argv[1], &V, &E);
	int e1[E], e2[E];
	bool loadedges = loadEdges(argv[1], e1, e2, E);
	if (!loadedspec || !loadedges) {
		std::cout << "c The input formula " << argv[1] << " could not be loaded." << std::endl;
		return 0;
	}
	void *solver = ipasir_init();
	initClauses(solver, V, E, e1, e2);
	int satRes = 20;
	// int counter = 2; 
	/**
	 * start with 2 colors 
	 * iterate as long as there is no solution
	 **/
	// while (satRes != 10) { 
	// for (int counter = 2; counter <= 3; counter ++) {
	int counter = 2;
	auto totalStart = std::chrono::high_resolution_clock::now(); 
	while (satRes != 10) {
		addClauses(solver, V, E, e1, e2, counter);
		for (int i = 2; i <= V; i++) {
			if (i == counter) ipasir_assume(solver, -1 * i);
			else ipasir_assume(solver, i);
		}
		std::cout << "c" << std::endl << "c Colors: " << counter << std::endl;
		auto start = std::chrono::high_resolution_clock::now(); 
		satRes = ipasir_solve(solver);
		auto stop = std::chrono::high_resolution_clock::now(); 
		auto duration = std::chrono::duration_cast<std::chrono::milliseconds> (stop - start).count();
		std::cout <<"c Runtime: " << duration << "ms" << std::endl;
		counter++;
	}
	counter --; 
	auto totalStop = std::chrono::high_resolution_clock::now(); 
	auto totalDuration = std::chrono::duration_cast<std::chrono::milliseconds> (totalStop - totalStart).count();
	std::cout <<"c Total runtime: " << totalDuration << "ms" << std::endl;
	if (satRes == 10) {
		std::cout << "c The input graph can be colored for " << counter << " colors" << std::endl;
		std::cout << "c Its formula is SATISFIABLE for:" << std::endl;
		std::cout << "v ";
		for (int var = V + 1; var <= V + counter * V; var++) {
			int value = ipasir_val(solver, var);
			if (value > 0) value = value - V;
			else value = value + V;
			std::cout << value << " ";
		}
		std:: cout << std::endl;
	}

	std::cout << "c Solution:" << std::endl;
	for (int node = 1; node <= V; node++) {
		for (int col = 0; col < counter; col++) {
			int value = ipasir_val(solver, V + col * V + node);
			if (value > 0) {
				std::cout << "c Node:" << node << " Color:" << col + 1 << std::endl;
			}
		}
	}
	return 0;
}