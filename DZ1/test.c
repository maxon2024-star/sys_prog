#include "stdio.h"

unsigned long * create_array(unsigned long);

unsigned long * free_memory();

void add_end(unsigned n,unsigned num );

long del_beg(unsigned n);

void fill_rnum(long size);

long count_prime();

long count_end_1();


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
        printf("%ld\n", myarr[i]);
    }

    for (int i = 0; i < n; i++){
       del_beg(n);
       n--;
    }
    return 0;
    long end_with_1 = count_end_1();
    return 0;
    long prime = count_prime();
    return 0;

    printf("простых: %ld, оканчиваются на 1: %ld\n", prime, end_with_1);
    


    free_memory(myarr);
    return 0;    
}