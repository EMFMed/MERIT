function [points, axes_] = get_points(resolution, varargin)
  if numel(resolution) == 1
    resolution = repmat(resolution, [1, 3]);
  end

  radius = 70e-3;
  radius_ = radius+5e-3;

  full_axis = @(r) -radius_:r:radius_;
  half_axis = @(r) 0:r:radius_;

  p = inputParser();
  validate_axis = @(a) validateattributes(a, {'numeric'}, {'vector', 'real'});
  addOptional(p, 'x', full_axis(resolution(1)), validate_axis);
  addOptional(p, 'y', full_axis(resolution(2)), validate_axis);
  addOptional(p, 'z', half_axis(resolution(3)), validate_axis);
  parse(p, varargin{:});

  axes_ = {p.Results.x, p.Results.y, p.Results.z};

  [Xs, Ys, Zs] = ndgrid(axes_{:});
  area_ = Xs.^2 + Ys.^2+Zs.^2 <= radius.^2;

  points = merit.beamform.imaging_domain(area_, axes_{:});
end
