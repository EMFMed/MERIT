function points = create_circumference(radius, number_of_points, starting_angle)
%{
Nx2
Returns an array of coordinates evenly divided around the circumference 
of a circle in 2D space.
%}
arguments
    % The circle's radius.
    radius (1, 1) {mustBeGreaterThanOrEqual(radius, 0)}
    % (N). The number of antennas. The antennas are set to be spaced out evenly.
    number_of_points (1, 1) {mustBeGreaterThanOrEqual(number_of_points, 0)}
    starting_angle
end

% The angles are evenly spaced
angles = (linspace(0, (1 - (1/number_of_points) ) * 2 * pi, number_of_points));
% The starting angle is not always 0 degrees.
angles = angles + starting_angle;

points = permute ( [ ( cos(angles) * radius ); ( sin(angles) * radius ) ], [2,1] );
end

