function [result] = under(op, f, f_, varargin)
  % applies f to the argument of the function op and f_, its inverse, to the output.
  %
  % e.g.
  %   norm = @(a) under(@sum, @(a) a.^2, @sqrt, a);

  args = cellfun(f, varargin, 'UniformOutput', false);
  result = f_(op(args{:}));
end
