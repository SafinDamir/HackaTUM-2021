function T4 = implicit_euler(Nx, Ny, dt)

x2 = (1 + Nx)^2; % (1/h_x)^2
y2 = (1 + Ny)^2; % (1/h_y)^2

% initial T distribution
T = zeros(Ny+2, Nx+2);
T(2:Ny+1, 2:Nx+1) = 1.;

T4 = zeros(Ny+2, Nx+2, 4);

t = [0:dt:.5];
N = length(t);

for n=1:N-1
	
	T = gauss_seidel(Nx, Ny, dt, T);
	
    for i = 1:4
        if abs(t(n+1) - i/8) < dt/2
        %if t(n+1) == i/8 % ofc this comparison is EMOTIONAL DAMAGE
            T4(:, :, i) = T;
        end
    end
end

end
