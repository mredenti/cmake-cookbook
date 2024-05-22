// main.cpp
#include "SimpleBLAS.h"
#include <iostream>

int main() {
    std::vector<double> x = {1.0, 2.0, 3.0};
    std::vector<double> y = {4.0, 5.0, 6.0};
    std::vector<double> result(3);

    SimpleBLAS::vectorAddition(x, y, result);
    std::cout << "Vector Addition Result: ";
    for (auto val : result) {
        std::cout << val << " ";
    }
    std::cout << "\n";

    std::vector<double> A = {1, 2, 3, 4, 5, 6}; // 2x3 matrix
    std::vector<double> v = {1, 1, 1};          // 3x1 vector
    std::vector<double> mv_result(2);
    SimpleBLAS::matrixVectorMultiply(A, v, mv_result, 2, 3);
    std::cout << "Matrix-Vector Multiply Result: ";
    for (auto val : mv_result) {
        std::cout << val << " ";
    }
    std::cout << "\n";

    std::vector<double> B = {1, 1, 1, 1};       // 3x2 matrix
    std::vector<double> mm_result(4);           // 2x2 result matrix
    SimpleBLAS::matrixMatrixMultiply(A, B, mm_result, 2, 3, 2);
    std::cout << "Matrix-Matrix Multiply Result: ";
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
