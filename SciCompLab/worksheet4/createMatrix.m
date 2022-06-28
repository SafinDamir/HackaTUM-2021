function [A] = createMatrix(Nx,Ny)
N = Nx * Ny;
hx = 1 / (Nx + 1);
hy = 1 / (Ny + 1);

pos = @(i, j) (j - 1) * Nx + i; 
%f_ij is x(pos(i, j))
%F_ij is b(pos(i, j))

%calculate elements in advance for optimization
dElem = -2/hx^2 - 2/hy^2; 
xElem = 1 / hx^2; 
yElem = 1 / hy^2;

A = zeros(N, N);
for i = 1:Nx
    for j = 1:Ny
        k = pos(i, j); %row of matrix A

        A(k, pos(i, j)) = dElem;
        if (j ~= Ny)
            A(k, pos(i, j+1)) = yElem;
        end
        if (j ~= 1)
        A(k, pos(i, j-1)) = yElem;
        end
        if (i ~= Nx)
        A(k, pos(i+1, j)) = xElem;
        end
        if (j ~= 1)
        A(k, pos(i-1, j)) = xElem;
        end
    end
end
