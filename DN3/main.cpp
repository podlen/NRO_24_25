#define _USE_MATH_DEFINES
#include <iostream>
#include <cmath>

//izracun arctan . taylorjeva vrsta
double calcAtan(double* x, int* N_steps) {
    double result = 0.0;
    for (int n = 0; n < *N_steps; ++n) {
        result += pow(-1, n) * pow(*x, 2 * n + 1) / (2 * n + 1);
    }
    return result;
}

double integral(double x) {
    return exp(3 * x) * calcAtan(new double(x / 2), new int(10)); 
}

double trapezno_pravilo(double a, double b, int n) {
    double dx = (b - a) / n;
    double sum = 0.5 * (integral(a) + integral(b));

    for (int i = 1; i < n; ++i) {
        double x = a + i * dx;
        sum += integral(x);
    }

    return sum * dx;
}

int main() {
    double a = 0.0, b = M_PI / 4;
    int delitve = 1000;

    double rez = trapezno_pravilo(a, b, delitve);

    std::cout << "Integral value: " << rez;

    return 0;
}