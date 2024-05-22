// src/MatrixVectorOps.cpp
#include "SimpleBLAS.h"

namespace SimpleBLAS {

void matrixVectorMultiply(const double* A, const double* x, double* result, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        result[i] = dotProduct(&A[i * cols], x, cols);
    }
}

} // namespace SimpleBLAS
