function [grid_] = get_slice(img, points, axes_, varargin)
  % slice = get_slice(img, points, axes_, 'z', 0.05);
  % Returns a slice of the image at z location 5 cm.

  p = inputParser;
  addOptional(p, 'z', 0);
  parse(p, varargin{:});

  isequaltol = @(a, b) abs(a-b)<1e-6;
  P = isequaltol(points(:, 3), p.Results.z);

  grid_ = merit.domain.img2grid(img(P), points(P, :), axes_{1:2}, p.Results.z);
end
