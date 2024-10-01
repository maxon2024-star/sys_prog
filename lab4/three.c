#include <stdio.h>
//#include <stdlib.h>
int main(){ 
    int n,sum = 0;
    //printf("Print n:\n");
    scanf("%d",&n);
    for(int i = 0; i<=n;i++){
        if(i%2 == 0){
        //printf("%d\n", zn*i*(i+1)*(3*i+1)*(3*i+2));
        sum+=i*(i+1)*(3*i+1)*(3*i+2);
        }
        else{
        //printf("%d\n", zn*i*(i+1)*(3*i+1)*(3*i+2));
        sum-=i*(i+1)*(3*i+1)*(3*i+2);
        }
    }
    
    printf("%d\n", sum);
    return 0;
}