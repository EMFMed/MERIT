function [result] = reshape2d(f, argument)
  % flattens trailing dimensions of the first input argument to func so functions
  %   operating on 2D arrays only will work.
  %   Output array is reshaped back to size of the original input.
  %
  %   result = reshape2d(f, argument);

  validateattributes(f, {'function_handle'}, {'scalar'}, mfilename, 'f', 1);
  
  original_size = size(argument);
  flatten = @(a) reshape(a, size(a, 1), []);
  restore = @(a) reshape(a, [size(a, 1), original_size(2:end)]);

  result = merit.utility.under(f, flatten, restore, argument);
end
