// Include in src/VectorOps.cpp or create a new file DotProduct.cpp

#include "SimpleBLAS.h"

namespace SimpleBLAS {

double dotProduct(const double* x, const double* y, int n) {
    double sum = 0.0;
    for (int i = 0; i < n; ++i) {
        sum += x[i] * y[i];
    }
    return sum;
}

} // namespace SimpleBLAS
