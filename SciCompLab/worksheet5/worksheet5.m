%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% worksheet5 - ?????
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function worksheet5()
clear;

% grid size cases
N = [3,7,15,31];
space_cases = length(N);

% possible timesteps
time_steps = [1/64, 1/128, 1/256, 1/512, 1/1024, 1/2048, 1/4096];
time_cases = length(time_steps);

%solvers
solvers_names = {"Explicit Euler", "Implicit Euler"};
solvers = {@explicit_euler, @implicit_euler};

% output containers
tiles_1 = utilities.make_tiled_figure(space_cases, time_cases, "Explicit Euler");
tiles_2 = utilities.make_tiled_figure(space_cases, time_cases, "Implicit Euler");
tiles = [tiles_1; tiles_2];

stability = zeros(space_cases, time_cases, length(solvers));

% case iteration
for III = 1:space_cases
    Nx = N(III);
    Ny = N(III);

    fprintf('processing case (%d, %d)...\n', Nx, Ny);
    [X, Y] = meshgrid(0:1/(Nx+1):1, 0:1/(Ny+1):1);
	
	for I = 1:length(solvers)
        fprintf(' -> using %s\n', solvers_names{I});
	
		for II = 1:time_cases
			T = solvers{I}(Nx, Ny, time_steps(II)); %contains T at 1/8, 2/8, 3/8 and 4/8
			utilities.draw(tiles(I, :), X, Y, T, time_steps(II));
			stability(III, II, I) = utilities.is_stable(T(4, :, :));
		end
	end
end

for I = 1:length(solvers)
	fprintf('Stable cases for %s:\n', solvers_names{I});
	disp(array2table(stability(:, :, I), 'RowNames', "Nx = Ny = " + string(N), ...
	'VariableNames', "dt = 1/" + string(1./time_steps)));
end

clear;
end
