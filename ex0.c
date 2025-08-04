extern void __ikos_assert(int condition);

void bar(void)
{
  int i=1;

  while(i < 10) {
    i++;
  }

  __ikos_assert(i == 10);
}   

int main() {
  bar();
}
