#include "plangen.hpp"
#include "sokoban.hpp"

#include <iostream>
#include <memory>

using namespace std;

const bool comments = false;

unique_ptr<Sokoban> sokoban;
unique_ptr<DimspecPlanGen> plan;

int main(int argc, char **argv) {
    if(argc != 2) {
        cout << "syntax error.\nSyntax: " << argv[0] << " [filename]" << endl;
        return 1;
    }


    sokoban = make_unique<Sokoban>(argv[1]);

    plan = make_unique<DimspecPlanGen>();
    if(!comments) plan->disableComments();

    // encode player position as the number of reachable blocks in binary
    auto playerPosVar = plan->addObject(sokoban->numReachable);
    plan->addInitial(playerPosVar,
        sokoban->map[sokoban->playerPos.y][sokoban->playerPos.x].reachableId);

    // encode hasBox for each reachable block
    auto hasBoxVars = plan->addObjects(sokoban->numReachable, 2);
    for(int i = 0; i < sokoban->numReachable; i++) {
        plan->addInitial(hasBoxVars[i], sokoban->getWithId(i).hasBox ? 1 : 0);
    }

    // goal: box on each goal block
    for(unsigned int y = 0; y < sokoban->height; y++) {
        for(unsigned int x = 0; x < sokoban->width; x++) {
            auto& block = sokoban->map[y][x];
            if(block.isGoal)
                plan->addGoal(hasBoxVars.at(block.reachableId), 1);
        }
    }

    // add actions

    for(unsigned int y = 0; y < sokoban->height; y++) {
        for(unsigned int x = 0; x < sokoban->width; x++) {
            auto& block = sokoban->map[y][x];

            if(!block.reachable)
                continue;

            auto makeMoveAction = [&](int offsetX, int offsetY) {
                auto& nextBlock = sokoban->map[y+offsetY][x+offsetX];

                std::vector<DimspecPlanGen::Assignment> pre, post;

                // player is here
                pre.push_back(
                    DimspecPlanGen::Assignment(playerPosVar, block.reachableId));
                
                // next tile is free
                pre.push_back(
                    DimspecPlanGen::Assignment(hasBoxVars[nextBlock.reachableId], 0));

                // action: player at next pos
                post.push_back(
                    DimspecPlanGen::Assignment(playerPosVar, nextBlock.reachableId));

                if(comments) 
                    plan->trans.out << "c (sokoban) add action move (" << x << "," << y << ") to (" << x+offsetX << "," << y+offsetY << ")\n";

                plan->addAction(pre, post);
            };

            auto makePushAction = [&](int offsetX, int offsetY) {
                auto& nextBlock = sokoban->map[y+offsetY][x+offsetX];
                auto& nextNextBlock = sokoban->map[y+2*offsetY][x+2*offsetX];

                std::vector<DimspecPlanGen::Assignment> pre, post;

                // player is here
                pre.push_back(
                    DimspecPlanGen::Assignment(playerPosVar, block.reachableId));
                
                // next tile has box
                pre.push_back(
                    DimspecPlanGen::Assignment(hasBoxVars[nextBlock.reachableId], 1));

                // next next tile is empty
                pre.push_back(
                    DimspecPlanGen::Assignment(hasBoxVars[nextNextBlock.reachableId], 0));

                // action: player at next pos
                post.push_back(
                    DimspecPlanGen::Assignment(playerPosVar, nextBlock.reachableId));

                // action: next tile is empty
                post.push_back(
                    DimspecPlanGen::Assignment(hasBoxVars[nextBlock.reachableId], 0));

                // action: next next tile has block
                post.push_back(
                    DimspecPlanGen::Assignment(hasBoxVars[nextNextBlock.reachableId], 1));

                if(comments) 
                    plan->trans.out << "c (sokoban) add action push (" << x << "," << y << ") to (" << x+offsetX << "," << y+offsetY << ")\n";

                plan->addAction(pre, post);
            };

            // move left
            if(x > 0 && sokoban->map[y][x-1].reachable) {
                makeMoveAction(-1, 0);
                if(x > 1 && sokoban->map[y][x-2].reachable)
                    makePushAction(-1, 0);
            }

            // move up
            if(y > 0 && sokoban->map[y-1][x].reachable) {
                makeMoveAction(0, -1);
                if(y > 1 && sokoban->map[y-2][x].reachable)
                    makePushAction(0, -1);
            }

            // move right
            if(x < sokoban->width - 1 && sokoban->map[y][x+1].reachable) {
                makeMoveAction(1, 0);
                if(x < sokoban->width - 2 && sokoban->map[y][x+2].reachable)
                    makePushAction(1, 0);
            }

            // move down
            if(y < sokoban->height - 1 && sokoban->map[y+1][x].reachable) {
                makeMoveAction(0, 1);
                if(y < sokoban->height - 2 && sokoban->map[y+2][x].reachable)
                    makePushAction(0, 1);
            }
        }
    }

    plan->writeDimspecToStdOut();
}