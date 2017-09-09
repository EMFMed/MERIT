function [varargout] = expand(varargin)
  dims = cellfun(@ndims, varargin);
  sizes = ones(numel(varargin), max(dims));
  for v = 1:numel(varargin)
    sizes(v, 1:dims(v)) = size(varargin{v});
  end

  for c = 1:size(sizes, 2)
    u_sizes = unique(sizes(:, c));
    if numel(u_sizes) ~= 1 && u_sizes(1) ~= 1
      error('merit:utility:expand', 'Dimensions need to be the same or one for all inputs.');
    end
  end

  varargout = varargin(1:nargout);
  repeats = bsxfun(@rdivide, max(sizes), sizes);
  for v = 1:numel(varargout)
    varargout{v} = repmat(varargout{v}, repeats(v, :));
  end
end
