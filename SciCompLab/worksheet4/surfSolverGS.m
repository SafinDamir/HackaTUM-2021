function [] = surfSolverGS(b, Nx, Ny)

T = solverGaussSeidelFast(b, Nx, Ny);

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