clc;
clear;
close all;

global ePrev
ePrev = NaN;

for n = [3, 7, 15, 31, 63, 127]
    A = createMatrix(n, n);
    b = createRightSide(n, n);
    
    figure('Name',sprintf('Solutions for a domain %ix%i.\n', n, n));
    tiledlayout(3, 2)
    
    fprintf('\n Gauss-Seidel method for a domain %ix%i.\n', n, n);
    surfSolverGS(b, n, n);
    fprintf('\n MATLAB direct solver for a full matrix %ix%i.\n', n, n);
    directMATLAB(full(A), b, n, n);
    fprintf('\n MATLAB direct solver for a sparse matrix %ix%i.\n', n, n);
    directMATLAB(sparse(A), b, n, n);
    fprintf('\n ----------------------------------------------------------\n');
end

