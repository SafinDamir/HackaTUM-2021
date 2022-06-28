function xg = sphere_fibonacci_grid_points (ng)

  phi = ( 1.0 + sqrt ( 5.0 ) ) / 2.0;

  i = ( - ( ng - 1 ) : 2 : ( ng - 1 ) )';
  theta = 2 * pi * i / phi;
  sphi = i / ng;
  cphi = sqrt ( ( ng + i ) .* ( ng - i ) ) / ng;

  xg = zeros ( ng, 3 );

  xg(1:ng,1) = cphi .* sin ( theta );
  xg(1:ng,2) = cphi .* cos ( theta );
  xg(1:ng,3) = sphi;

  return
end
