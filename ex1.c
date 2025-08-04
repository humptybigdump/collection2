#include "intrinsic.h"

void foo(int n)
{
  int i = 1, s = 1;

  while(i < n) {
    s *= i;
    i += 2;
  }

  __ikos_assert(s % 2 != 0);
}

void main() {
  int n = __ikos_nondet_int();
  foo(n);
}

// Run with the right abstract domain.
//   ikos -a prover -d ________ ex1.c
