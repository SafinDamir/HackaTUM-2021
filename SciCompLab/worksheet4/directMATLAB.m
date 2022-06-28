function [] = directMATLAB(A, b, Nx, Ny)

tStart = tic;
x = A\b;
tEnd = toc(tStart);
fprintf('   Time needed = %.2d.\n', tEnd);
stor = nzmax(A) + nzmax(b) + nzmax(x);
fprintf('   Storage needed = %i.\n', stor);

T = zeros(Nx, Ny);
pos = @(i, j) (j - 1) * Nx + i; 
for i = 1:Nx
    for j = 1:Ny
        T(i, j) = x(pos(i, j));
    end
end

Tb = zeros(Nx + 2, Ny + 2);
Tb (2:Nx+1, 2:Ny+1) = T;
[X, Y] = meshgrid(linspace(0, 1, Ny+2), linspace(0, 1, Nx+2));

nexttile
surf(X, Y, Tb);
colorbar;
nexttile
contour(X, Y, Tb);
colorbar;
end