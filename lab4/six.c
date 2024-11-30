#include <stdio.h>

int main()
{
int limit, sum =0;
scanf("%d",&limit);

for (int n = 0; n <= limit; n++)
{
if ((n % 7 && n % 3) !=0  && n % 5 == 0){
    sum++;
    //printf("%d\n", n);
}
}
printf("%d\n", sum);
return 0;
}