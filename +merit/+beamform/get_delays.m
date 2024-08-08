function [calculate_time] = get_delays(channels, antennas, options)
  %% [calculate_time] = get_delays(channels, antennas, options)
  %  returns a function which takes a list of points (x, y) or (x, y ,z) across the rows
  %  and returns the times for each channel to each point.
  %  channels: a C × 2 array for which antenna location is transmitting and receiving
  %  antennas: an A × D array for the antenna locations
  %  options: relative permittivity
  
arguments
  channels (:, 2) {mustBePositive, mustBeInteger}
  antennas (:, 3) {mustBeReal}
  options.relative_permittivity {mustBeNumeric, mustBeScalarOrEmpty, mustBeGreaterThanOrEqual(options.relative_permittivity,1)}     % relative permittivity must be a nummeric scaler >= 1
end
  c_0 = 299792458;  % speed of light in a vacuum
  relative_permittivity = options.relative_permittivity;

  speed = c_0./sqrt(relative_permittivity); %speed relative to speed of light

  antennas = antennas'; % transpose antennas array
  
  function [time] = calculate_(points)
    % permute: lets say points is a 4 x 5 x 6 (4 rows, 5 columns, 6 pages) matrix
    % permute (points [2,3,1]) tells us that there are 4 columns, 5 pages
    % and 6 rows in the new points array

    points = permute(points, [2, 3, 1]);
    distances = sqrt(sum( (antennas - points).^2, 1) );

    time = - ( distances(:, channels(:, 1), :) + distances(:, channels(:, 2), :) ) / speed;
  end
  calculate_time = @calculate_;
end
