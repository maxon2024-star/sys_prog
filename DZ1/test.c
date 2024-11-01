#include "stdio.h"

unsigned long * create_array(unsigned long);

unsigned long * free_memory();

void add_end(unsigned n,unsigned num );

void del_beg(unsigned n);

void fill_rnum(long n);

long count_prime(long n);

long count_end_1(long n);


int main(){
    //return 0; 
    unsigned long *myarr, n;
    scanf("%ld",&n);
    myarr = create_array(n);

    fill_rnum(n);

    long el = 999; 
    for (;el < 1004; el++){
        add_end(n,el);
        n++;
    } 

    for (int i = 0; i < n; i++){
        printf("%ld ", myarr[i]);
    }
    printf("\n");

    long end_with_1 = count_end_1(n);
    printf("оканчиваются на 1: %ld\n", end_with_1);

    long prime = count_prime(n);
    printf("простых: %ld\n", prime);


    for (int i = 0; i < n; i++){
       del_beg(n);
       n--;
    }

    free_memory(myarr);
    return 0;    
}