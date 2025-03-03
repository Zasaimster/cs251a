#include <stdio.h>

float reverse_subtract(float in1, float in2) {
    float ret = 0.0;
    asm ("fsubr %2, %0" : "=&t" (ret) : "%0" (in1), "u" (in2));
    return ret;
}

int main() {
    float in1, in2;
    float result;
    float pi = 3.141592;

    for (int i = 0; i < 10; i++) {
        in1 = pi;
        in2 = i*pi;
        result = reverse_subtract(in1, in2);
        printf("reverse_subtract(%f, %f) = %f\n", in1, in2, result);
    }
}
