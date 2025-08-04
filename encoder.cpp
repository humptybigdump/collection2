#include <iostream>
#include <string>
#include <vector>
#include <tuple>
#include <algorithm>

using namespace std;

void swap(int& a, int& b) {
    int temp = a;
    a = b;
    b = temp;
}

int main(int argc, char **argv) {
    int n = stoi(string(argv[1]));

    vector<tuple<int,int,int>> triples;
    vector<bool> usedVars(n);
    for(int i = 0; i < n; i++) usedVars[i] = false;
    for(int a = 1; a <= n; a++) {
        for(int b = 1; b <= n; b++) {
            for(int c = 1; c <= n; c++) {
                if(a*a + b*b == c*c) {
                    usedVars[a-1] = true;
                    usedVars[b-1] = true;
                    usedVars[c-1] = true;
                    int A = a;
                    int B = b;
                    int C = c;
                    if(A > B) swap(A, B);
                    if(B > C) swap(B, C);
                    if(A > B) swap(A, B);
                    if(B > C) swap(B, C);
                    auto t = make_tuple(A, B, C);
                    if(find(triples.begin(), triples.end(), t) == triples.end())
                        triples.push_back(make_tuple(a,b,c));
                }
            }
        }
    }
    cout << "c pythagorean triple with n=" << n << endl;
    
    int numUnused = 0;
    // count unit clauses for unused vars
    for(int i = 0; i < n; i++) {
        if(!usedVars[i]) {
            numUnused++;
        }
    }

    cout << "p cnf " << n << " " << 2 * triples.size() + numUnused << endl;

    for(auto t : triples) {
        cout << get<0>(t) << " " << get<1>(t) << " " << get<2>(t) << " 0" << endl;
        cout << -get<0>(t) << " " << -get<1>(t) << " " << -get<2>(t) << " 0" << endl;
    }

    // add unit clauses for unused vars
    for(int i = 0; i < n; i++) {
        if(!usedVars[i]) {
            cout << i+1 << " 0" << endl;
        }
    }

}