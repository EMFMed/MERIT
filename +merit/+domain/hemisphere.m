function [points, axes_] = hemisphere(varargin)
  % [points, axes_] = merit.domain.hemisphere('radius', r, 'resolution', res)
  %   points is a list of points in a hemisphere with resolution spacing between them.
  %   axes_ is the discrete points in each direction.
  %   r is the radius of the hemisphere
  %   resolution is the spacing between points and can be different for each axis.
  p = inputParser();
  validate_axis = @(a) validateattributes(a, {'numeric'}, {'vector', 'real'});
  addOptional(p, 'resolution', 1e-3, @(a) validateattributes(a, {'numeric'}, {'real'}));
  addOptional(p, 'radius', 7e-2, @(a) validateattributes(a, {'numeric'}, {'scalar', 'real'}));
  addOptional(p, 'x', [], validate_axis);
  addOptional(p, 'y', [], validate_axis);
  addOptional(p, 'z', [], validate_axis);
  parse(p, varargin{:});
  resolution = p.Results.resolution;
  if numel(resolution) == 1
    resolution = repmat(resolution, [1, 3]);
  end

  radius_ = p.Results.radius+5e-3;

  full_axis = @(r) -radius_:r:radius_;
  half_axis = @(r) 0:r:radius_;
  axes_ = {p.Results.x, p.Results.y, p.Results.z};
  if isempty(axes_{1})
    axes_{1} = full_axis(resolution(1));
  end
  if isempty(axes_{2})
    axes_{2} = full_axis(resolution(2));
  end
  if isempty(axes_{3})
    axes_{3} = half_axis(resolution(3));
  end

  [Xs, Ys, Zs] = ndgrid(axes_{:});
  area_ = Xs.^2 + Ys.^2+Zs.^2 <= p.Results.radius.^2;

  points = merit.beamform.imaging_domain(area_, axes_{:});
end
