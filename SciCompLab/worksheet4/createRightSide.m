function [b] = createRightSide(Nx, Ny)
pos = @(i, j) (j - 1) * Nx + i; 
hx = 1 / (Nx + 1);
hy = 1 / (Ny + 1);
N = Nx * Ny;
b = zeros(N, 1);
for i = 1:Nx
    for j = 1:Ny
        b(pos(i, j)) = -2*pi^2*sin(pi * i * hx) * sin(pi * j * hy);
    end
end
end

