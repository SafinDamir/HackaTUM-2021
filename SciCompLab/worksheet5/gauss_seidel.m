%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gauss_seidel - implements iterative method of Gauss-Seidel
%           via direct computing and updating (i,j) value through
%           disc. diff. operator, with the following form:
%
%           T{i,j} = ( (T{i-1,j} + T{i+1,j})/h_x^2 + 
%                       (T{i,j-1} + T{i,j+1})/h_y^2 ) /(2(1/h_x^2+h_y^2))
%
%           starting from initial guess T==0
%
%	T = gauss_seidel(b, Nx, Ny)
%
%--------
% Input: 
%--------
%	Nx		number of points along x axis
%	Ny		number of points along y axis
%	b		right hand side of the equation
%
%--------
% Output: 
%--------
%	T		inner domain (Ny, Nx)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function T_new = gauss_seidel(Nx, Ny, dt, T)
tol = 1e-6;
x2 = (1 + Nx)^2; % (1/h_x)^2
y2 = (1 + Ny)^2;

T_new = T; % initial guess to make it faster?
I = 0;

while (residual_comparison(T_new, T, dt, Nx, Ny, tol) && I < 100)
    for j = 2:Ny+1
        for i = 2:Nx+1
            T_new(j,i) = ( T_new(j,i) + ...
            ( (T_new(j-1,i) + T_new(j+1,i))*y2 + (T_new(j,i-1) + T_new(j,i+1))*x2 )*dt ) /...
            		(1 + 2*dt*(y2+x2));
        end
    end
    I = I+1;
end
end
