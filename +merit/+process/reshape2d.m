function [result] = reshape2d(f, varargin)
  % flattens trailing dimensions of the first input argument to func so functions
  %   operating on 2D arrays only will work.
  %   Output array is reshaped back to size of the original input.
  %
  %   result = reshape2d(f, argument);

  validateattributes(f, {'function_handle'}, {'scalar'}, mfilename, 'f', 1);
  
  original_size = size(varargin{1});
  for v = 2:numel(varargin)
    size_ = size(varargin{v});
    if ~isequal(size_(2:end), original_size(2:end)),
      error('merit:utility:reshape2d', 'Input arrays must have the same trailing dimension sizes');
    end
  end
  
  flatten = @(a) reshape(a, size(a, 1), []);
  restore = @(a) reshape(a, [size(a, 1), original_size(2:end)]);

  result = merit.utility.under(f, flatten, restore, varargin{:});
end
