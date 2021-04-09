#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "helloworld.h"
#include "print.h"

int main(int argc, char **argv)
{
    helloworld();
    printf("sin(pi/2) = %0.2f\n", sin(3.14/2.));
    double b = 3.14;
    DISP(b);
    return 0;
}