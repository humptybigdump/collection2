#include "plangen.hpp"

#include <vector>
#include <string>

using namespace std;

DimspecPlanGen plan;

// [y][x]
vector<vector<int>> initialState;
vector<vector<int>> goalState;
vector<vector<DimspecPlanGen::Variable>> variables;
int width, height;
int numPieces;
DimspecPlanGen::Type cellType;

const bool comments = false;

int main(int argc, char **argv) {
    if(argc != 2) {
        cout << "c Invalid number of arguments. Syntax: " << argv[0] << " 123-456-780" << endl;
        return 1;
    }

    if(!comments) plan.disableComments();

    //comments above first cnf header are allowed
    cout << "c sliding puzzle problem with " << argv[1] << endl;

    int pos = 1;
    initialState.push_back(vector<int>());
    goalState.push_back(vector<int>());
    for(char c : string(argv[1])) {
        if(c == '-') {
            initialState.push_back(vector<int>());
            goalState.push_back(vector<int>());
        } else {
            int num = -1;
            if(c >= '0' && c <= '9') num = c - '0';
            if(c >= 'A' && c <= 'F') num = c - 'A' + 10;
            if(c >= 'a' && c <= 'f') num = c - 'a' + 10;
            initialState.back().push_back(num);
            goalState.back().push_back(pos++);
        }
    }

    width = initialState[0].size();
    height = initialState.size();

    cout << "c width: " << width << endl;
    cout << "c height: " << height << endl;

    for(int y = height - 1; y >= 0; y--) {
        cout << "c  ";
        for(int x = 0; x < width; x++)
            cout << static_cast<char>(initialState[y][x]
                + (initialState[y][x] >= 10 ? ('A' - 10) : '0')) << " ";
        cout << endl;
    }


    goalState[height-1][width-1] = 0;

    int numPieces = 0;
    for(auto& v : initialState)
        for(int i : v)
            numPieces = max(numPieces, i);
    cellType = numPieces + 1;

    // specify action grouping size
    plan.setActionGroupSize(
        (std::min(width, height) - 1) * 2 * numPieces);

    // create variables for cells
    for(int y = 0; y < height; y++)
        variables.push_back(plan.addObjects(width, cellType));

    // specity initial state
    for(int y = 0; y < height; y++)
        for(int x = 0; x < width; x++)
            plan.addInitial(variables[y][x], initialState[y][x]);

    // specify goal state
    for(int y = 0; y < height; y++)
        for(int x = 0; x < width; x++)
            plan.addGoal(variables[y][x], goalState[y][x]);

    // specify actions
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            for(int value = 1; value <= numPieces; value++) {

                auto makeAction = [&](int offsetX, int offsetY) {
                    std::vector<DimspecPlanGen::Assignment> precond;
                    std::vector<DimspecPlanGen::Assignment> effect;

                    precond.push_back(
                        DimspecPlanGen::Assignment{variables[y][x], 0});
                    precond.push_back(
                        DimspecPlanGen::Assignment{variables[y+offsetY][x+offsetX], value});
                    effect.push_back(
                        DimspecPlanGen::Assignment{variables[y][x], value});
                    effect.push_back(
                        DimspecPlanGen::Assignment{variables[y+offsetY][x+offsetX], 0});

                    if(comments)
                        plan.trans.out << "c add action (" << x << "," << y << ") -> ("
                            << x+offsetX << "," << y+offsetY << ")" << " for value " << value << endl;
                    plan.addAction(precond, effect);
                };

                // action: shift right
                if(x < width - 1) {
                    makeAction(1, 0);
                }

                // action: shift up
                if(y < height - 1) {
                    makeAction(0, 1);
                }

                // action: shift left
                if(x > 0) {
                    makeAction(-1, 0);
                }

                // action: shift down
                if(y > 0) {
                    makeAction(0, -1);
                }
            }
        }
    }

    plan.writeDimspecToStdOut();
}
