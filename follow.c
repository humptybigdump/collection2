#include "follow.h"
#include "token_multi_set.h"
#include "lexer.h"

#include <assert.h>

static token_multi_set_t follow_set = {0};

static void __attribute__((constructor)) initialize(void)
{
	follow_set = init_token_multi_set(0);
}

token_multi_set_t get_follow()
{
	return follow_set;
}

void add_follow(token_type_t type)
{
	add_token(&follow_set, type);
}

void add_many_follows(const token_multi_set_t *tms)
{
	add_token_multi_set(&follow_set, tms);
}

void remove_follow(token_type_t type)
{
	remove_token(&follow_set, type);
}

void remove_many_follows(const token_multi_set_t *tms)
{
	remove_token_multi_set(&follow_set, tms);
}
