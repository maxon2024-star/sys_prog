#include <stdio.h>

int main()
{
int n;
scanf("%d",&n);
int rev=0,rem;
while(n>0)
{
    rem=n%10; //take out the remainder .. so it becomes 5 for 12345
    rev=rev*10+rem; //multiply the current number by 10 and add this remainder.
    n=n/10; //divide the number. So it becomes 1234.
}
printf("%d",rev);
return 0;
}