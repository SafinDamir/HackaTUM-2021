%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% residual_comparison - computes and compares linear system Ax=b residual
%           to given tolerance for heat equation with finite difference 
%           second deriv. approximation where:
%               residual = (1/Nx/Ny*sum(b_k-sum(a_{k,m}*x_m)))^.5
%
%	stop_algorithm = residual_comparison(M, b, Nx, Ny, tol)
%
%--------
% Input: 
%--------
%	Nx		number of points along x axis
%	Ny		number of points along y axis
%	M_rhs	right hand side of the equation
%   M       solution of the system (in matrix form)
%   tol     required accuracy
%
%--------
% Output: 
%--------
%	stop_algorithm    true weather tol > residual
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function stop_algorithm = residual_comparison(M, M_rhs, dt, Nx, Ny, tol)

x2 = (1 + Nx)^2; % (1/h_x)^2
y2 = (1 + Ny)^2;
R = 0;
stop_algorithm = false;

for j = 2:Ny+1
    for i = 2:Nx+1

        R = R + (M_rhs(j, i) - (M(j, i) - dt*((M(j-1, i) + M(j+1, i))*y2 ...
            - 2*(x2+y2)*M(j, i) + (M(j, i-1) + M(j, i+1))*x2)))^2;

        % such dynamic comparison makes residual analysis 10 times faster
        if (R/Nx/Ny)^.5 > tol
            stop_algorithm = true;
            return
        end
    end
end

end
