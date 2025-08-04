#ifndef FOLLOW_H
#define FOLLOW_H

#include "token_multi_set.h"

/**
 * An API for tracking dynamic Follow sets (right contexts)
 **/

void add_follow(token_type_t type);
void remove_follow(token_type_t type);
void add_many_follows(const token_multi_set_t *tms);
void remove_many_follows(const token_multi_set_t *tms);
token_multi_set_t get_follow();

#endif
