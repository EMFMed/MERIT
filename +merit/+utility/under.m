function [result] = under(op, f, f_, argument)
  % applies f to the argument of the function op and f_, its inverse, to the output.
  %
  % e.g.
  %   norm = @(a) under(@sum, @(a) a.^2, @sqrt, a);

  result = f_(op(f(argument)));
end
