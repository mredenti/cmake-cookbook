#ifndef BLAS_HPP
#define BLAS_HPP

#include <vector>

namespace BLAS {

// Level 1: Dot Product
void dotProduct(const std::vector<double>& x, const std::vector<double>& y, std::vector<double>& result);

// Level 2: Matrix-Vector Operations
void matrixVectorMultiply(const std::vector<double>& A, const std::vector<double>& x, std::vector<double>& result, int rows, int cols);

// Level 3: Matrix-Matrix Operations
void matrixMatrixMultiply(const std::vector<double>& A, const std::vector<double>& B, std::vector<double>& C, int rowsA, int colsA, int colsB);

} // namespace SimpleBLAS

#endif // SIMPLE_BLAS_H
