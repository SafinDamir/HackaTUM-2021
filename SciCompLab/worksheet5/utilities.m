classdef utilities
    methods(Static)
        function surf_tiles = make_tiled_figure(space_cases, time_cases, method_name)
        	tt = [1/8, 2/8, 3/8, 4/8];
            for i = 1:4
                surf_fig(i) = figure('Name', sprintf('Solutions using %s at time T = %0.3f', ...
                	method_name, tt(i)), 'units', 'normalized', 'OuterPosition', [0 0 1 1]);
				
				surf_tiles(i) = tiledlayout(surf_fig(i), space_cases, time_cases);
            end
        end

        function draw(surf_tiles, X, Y, T, dt)
        	tt = [1/8, 2/8, 3/8, 4/8];
        	for i=1:4
        		N = size(T(:, :, i), 1);
        		nexttile(surf_tiles(i));
				surf(X, Y, T(:, :, i));

				colorbar;
				title(sprintf('Nx=%d, dt=1/%d', N, 1/dt));
				xlabel('x');
				ylabel('y');
				zlabel('T(x,y)');
			end
		end
		
		function stability = is_stable(T)
			stability = 0;
            if all(T <= 1.0, 'all') && all(T >= 0.0, 'all')
				stability = 1;
            end
		end
		
    end
end
