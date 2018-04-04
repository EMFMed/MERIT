function [calculate_time] = get_delays(channels, antennas, varargin),
  c_0 = 299792458;
  p = inputParser;
  addOptional(p, 'relative_permittivity', 1, @(a) isnumeric(a) && numel(a) == 1 && a >= 1);
  parse(p, varargin{:});
  relative_permittivity = p.Results.relative_permittivity;

  speed = c_0./sqrt(relative_permittivity);

  antennas = antennas';
  
  function [time] = calculate_(points),
    points = permute(points, [2, 3, 1]);
    distances = sqrt(sum(bsxfun(@minus, antennas, points).^2, 1));

    time = -bsxfun(@rdivide, distances(:, channels(:, 1), :) + distances(:, channels(:, 2), :), speed);
  end
  calculate_time = @calculate_;
end
