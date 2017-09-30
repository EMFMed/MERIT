function [linear] = linearlysampled(axis_)
  % returns true if axis_ has a constant timestep, false otherwise
  %
  % e.g
  %   islinear = linearlysampled(axis_);

  tolerance = 10*max(eps(axis_));
  steps = diff(axis_, 2);

  linear = all(steps <= tolerance);
end
