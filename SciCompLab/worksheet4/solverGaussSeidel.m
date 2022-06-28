function [T] = solverGaussSeidel(b, Nx, Ny)
tol = 1e-4;
iter = 1;

N = Nx * Ny;
hx = 1 / (Nx + 1);
hy = 1 / (Ny + 1);

dElem = -2/hx^2 - 2/hy^2; 
xElem = 1 / hx^2; 
yElem = 1 / hy^2;

T = zeros(Nx, Ny);
x = zeros(N, 1);

pos = @(i, j) (j - 1) * Nx + i; 
repos  = @(k) [1 + mod(k-1, Nx) 1+floor((k-1) / Nx)];

resNorm = 1 + tol;
tic;

while (resNorm > tol) && (iter <= 1)
    for k = 1:N
        iandj = repos(k);
        i = iandj(1);
        j = iandj(2);

        %fprintf('i = %i; j = %i; k = %i \n', i, j, k)
        

        if (i ~= 1 && i ~= Nx && j ~= 1 && j ~= Ny) %inner ponts (consider first as it's general)
            x(k) = (b(k) - xElem * (x(pos(i+1, j)) + x(pos(i-1, j))) - yElem * (x(pos(i, j - 1)) + x(pos(i, j + 1))))/dElem;      
        elseif (i == 1 && j ~= Ny && j ~= 1)
            x(k) = (b(k) - xElem * x(pos(i+1, j)) - yElem * (x(pos(i, j - 1)) + x(pos(i, j + 1))))/dElem;
        elseif (i == Nx && j ~= Ny && j ~= 1)
            x(k) = (b(k) - xElem * x(pos(i-1, j)) - yElem * (x(pos(i, j - 1)) + x(pos(i, j + 1))))/dElem;
        elseif (i ~= Nx && i ~= 1 && j == 1)
            x(k) = (b(k) - xElem * (x(pos(i+1, j)) + x(pos(i-1, j))) - yElem * x(pos(i, j + 1)))/dElem;
        elseif (i ~= Nx && i ~= 1 && j == Ny)
            x(k) = (b(k) - xElem * (x(pos(i+1, j)) + x(pos(i-1, j))) - yElem * x(pos(i, j - 1)))/dElem;
        elseif (i == 1 && j == 1)
            x(k) = (b(k) - xElem * x(pos(i+1, j)) - yElem * x(pos(i, j + 1)))/dElem;      
        elseif (i == 1 && j == Ny)
            x(k) = (b(k) - xElem * x(pos(i+1, j)) - yElem * x(pos(i, j - 1)))/dElem;    
        elseif (i == Nx && j == 1)
            x(k) = (b(k) - xElem * x(pos(i-1, j)) - yElem * x(pos(i, j + 1)))/dElem;       
        elseif (i == Nx && j == Ny)
            x(k) = (b(k) - xElem * x(pos(i-1, j)) - yElem * x(pos(i, j - 1)))/dElem;       
        else
            disp('Point was lost!')
        end
        
    end
    
    sumR = 0;
    for k = 1:N
        iandj = repos(k);
        i = iandj(1);
        j = iandj(2);
        
        %fprintf('i = %i; j = %i; k = %i \n', i, j, k);

        if (i ~= 1 && i ~= Nx && j ~= 1 && j ~= Ny) %inner ponts (consider first as it's general)
            curR = (b(k) - dElem * x(pos(i, j)) - xElem * (x(pos(i+1, j)) + x(pos(i-1, j))) - yElem * (x(pos(i, j - 1)) + x(pos(i, j + 1))));      
        elseif (i == 1 && j ~= Ny && j ~= 1)
            curR  = (b(k) - dElem * x(pos(i, j)) - xElem * x(pos(i+1, j)) - yElem * (x(pos(i, j - 1)) + x(pos(i, j + 1))));
        elseif (i == Nx && j ~= Ny && j ~= 1)
            curR = (b(k) - dElem * x(pos(i, j)) - xElem * x(pos(i-1, j)) - yElem * (x(pos(i, j - 1)) + x(pos(i, j + 1))));
        elseif (i ~= Nx && i ~= 1 && j == 1)
            curR = (b(k) - dElem * x(pos(i, j)) - xElem * (x(pos(i+1, j)) + x(pos(i-1, j))) - yElem * x(pos(i, j + 1)));
        elseif (i ~= Nx && i ~= 1 && j == Ny)
            curR = (b(k) - dElem * x(pos(i, j)) - xElem * (x(pos(i+1, j)) + x(pos(i-1, j))) - yElem * x(pos(i, j - 1)));
        elseif (i == 1 && j == 1)
            curR = (b(k) - dElem * x(pos(i, j)) - xElem * x(pos(i+1, j)) - yElem * x(pos(i, j + 1)));      
        elseif (i == 1 && j == Ny)
            curR = (b(k) - dElem * x(pos(i, j)) - xElem * x(pos(i+1, j)) - yElem * x(pos(i, j - 1)));    
        elseif (i == Nx && j == 1)
            curR = (b(k) - dElem * x(pos(i, j)) - xElem * x(pos(i-1, j)) - yElem * x(pos(i, j + 1)));       
        elseif (i == Nx && j == Ny)
            curR = (b(k) - dElem * x(pos(i, j)) - xElem * x(pos(i-1, j)) - yElem * x(pos(i, j - 1)));       
        else
            disp('Point was lost!')
        end
        sumR = sumR + curR^2;
    end
    resNorm = sqrt(sumR / N);
    %disp(resNorm);
    iter = iter + 1;
end
toc;


fprintf('Calculation finished at iter = %i.\n', iter);
for i = 1:Nx
    for j = 1:Ny
        T(i, j) = x(pos(i, j));
    end
end
end