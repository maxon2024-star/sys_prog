#include "stdio.h"

long * create_array(long long);

long * free_memory();

long sum(long n);

void fill_rnum(long n);

long count_prime(long n);

long count_end_1(long n);


int main(){
    long *myarr, *myrevarr, n;
    scanf("%ld",&n);
    myarr = create_array(n);
    //fill_array(n);
    fill_rnum(n);

    for (int i = 0; i < n; i++){
        printf("%ld ", myarr[i]);
    }
    printf("\n");

    long end_with_1 = count_end_1(n);
    printf("оканчиваются на 1: %ld\n", end_with_1);

    long prime = count_prime(n);
    printf("простых: %ld\n", prime);

    long s = sum(n);
    printf("сумма: %ld\n", s);

    myrevarr = create_array(n);
    free_memory();

    return 0;    
}