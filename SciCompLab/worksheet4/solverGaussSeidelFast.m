function [T] = solverGaussSeidelFast(b, Nx, Ny)
tol = 1e-4;
iter = 0;

N = Nx * Ny;
hx = 1 / (Nx + 1);
hy = 1 / (Ny + 1);

dElem = -2/hx^2 - 2/hy^2; 
xElem = 1 / hx^2; 
yElem = 1 / hy^2;

T = zeros(Nx + 2, Ny + 2);

pos = @(i, j) (j - 1) * Nx + i; %position of right side in vector b for i and j

resNorm = 1 + tol;

%elements we need to store for the solution part:
%dElem, xElem, yElem, b (right side), T (expanded solution matrix), curR,
%sumR, resNorm (resudual norm), tol (tolerance), pos (function), Nx, Ny

%elements that to not depend on implementation:
%dElem, xElem, yElem, b (right side), T (expanded solution matrix);
%3 + Nx*Ny + (Nx+2) * (Ny+2) = 2 * Nx*Ny + 2*Nx + 2*Ny + 7 doubles;
%other elements are O(1) in storage;
tStart = tic;

while (resNorm > tol) && (iter <= 50000)
    for i=2:Ny+1
        for j=2:Ny+1
            T(i, j) = (b(pos(i-1, j-1)) - xElem * (T(i-1, j) + T(i+1, j)) - yElem * (T(i, j-1) + T(i, j+1)))/dElem;
        end
    end
    
    sumR = 0;

    for i=2:Ny+1
        for j=2:Ny+1
            curR = (b(pos(i-1, j-1)) - dElem * T(i, j) - xElem * (T(i+1, j) + T(i-1, j)) - yElem * (T(i, j-1) + T(i, j+1))); 
            sumR = sumR + curR^2;
        end
    end
    resNorm = sqrt(sumR / N);
    iter = iter + 1;
end

tEnd = toc(tStart);

fprintf('   Time needed = %.2d.\n', tEnd);
fprintf('   Calculation finished at iter = %i.\n', iter);

stor = nzmax(T) + nzmax(dElem) + nzmax(xElem) + nzmax(yElem) + nzmax(b);
fprintf('   Storage needed = %i.\n', stor);

T = T(2:Nx+1, 2:Ny+1);

solution = zeros(Nx, Ny);
for i = 1:Nx
    for j=1:Ny
        solution(i, j) = sin(pi * i * hx) * sin(pi * j * hy);
    end
end

e = sqrt(sum((T - solution).^2, 'all') / N);

fprintf('   Error = %.2d.\n', e);

global ePrev
if ~isnan(ePrev)
    fprintf('   Error reduction = %.2f.\n', ePrev / e);
end
ePrev = e;

end