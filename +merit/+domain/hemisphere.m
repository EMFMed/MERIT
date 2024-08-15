function [points, axes_] = hemisphere(radius, options)
% Create a hemisphere (or circle).
%{  
points is a list of points in a hemisphere with resolution spacing between them.
axes_ is the discrete points in each direction.
r is the radius of the hemisphere
resolution is the spacing between points and can be different for each axis.
%}
arguments
  radius (1,1)
  % Only either resolution or pixel dimensions can and must be chosen.
  options.resolution {mustBeNumericOrRealVectorOrEmpty} = []
  options.pixel_dim = []

  % Remove the z axis. This turns the hemisphere into a circle
  options.no_z = false  % no_z (no z axis) is default false
end

% Ensure that only one of the inputs is provided
if ~isempty(options.resolution)
    if ~isempty(options.pixel_dim)
        error('Only either the resolution or pixel dimensions can be specified. Not both.');
    else
        resolution = options.resolution;
    end
elseif ~isempty(options.pixel_dim)
        resolution = (2*radius) ./ ( options.pixel_dim - 1);
else
    error('Either resolution or pixel dimensions must be provided.');
end

if isscalar(resolution)
    resolution = repmat(resolution, [1, 3]);
end

function value = fun_full_axis(step)
    value = -radius:step:radius;
end

function value = fun_half_axis(step)
    value = 0:step:radius;
end

full_axis = @fun_full_axis;
half_axis = @fun_half_axis;

%for a 3D hemishpere:
if options.no_z == false
  axes_ = {[], [], []};

  %if left unspecified, create axes using the radius
  if isempty(axes_{1})
    axes_{1} = full_axis(resolution(1));
  end
  if isempty(axes_{2})
    axes_{2} = full_axis(resolution(2));
  end
  if isempty(axes_{3})
    axes_{3} = half_axis(resolution(3));
  end

  %use ndgrid to map the axes into points
  [Xs, Ys, Zs] = ndgrid(axes_{:});

  % get the area using the equation of a sphere
  area_ = Xs.^2 + Ys.^2+Zs.^2 <= radius.^2;
else
   % if no z axis needed:

  % create axes using radius if not specified 
  axes_ = {[], []};
  if isempty(axes_{1})
    axes_{1} = full_axis(resolution(1));
  end
  if isempty(axes_{2})
    axes_{2} = full_axis(resolution(2));
  end

  % use ndgrid to map axes into points
  [Xs, Ys] = ndgrid(axes_{:});

  % get area using equation of a circle
  area_ = Xs.^2 + Ys.^2 <= radius.^2;
end

% use area and axes to get the set of points in the imaging domain only
points = merit.beamform.imaging_domain(area_, axes_{:});
end

function mustBeNumericOrRealVectorOrEmpty(a)
    if ~isempty(a)
        validateattributes(a, {'numeric'}, {'vector', 'real'})
    end
end