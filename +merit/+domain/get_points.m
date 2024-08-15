function [points] = imaging_domain(domain, varargin)
  if numel(varargin) < 1
    ndim = ndims(domain);
  else
    ndim = numel(varargin);
  end

  coords = cell(1, ndim);
  domain_range = arrayfun(@(x) 1:size(domain, x), 1:ndim, 'UniformOutput', false);
  [coords{:}] = ndgrid(domain_range{:});
  coords = cellfun(@(x) x(domain), coords, 'UniformOutput', false);

  % Put in correct units
  if numel(varargin) >= 1
    coords = arrayfun(@(n) varargin{n}(coords{n}), 1:numel(varargin), 'UniformOutput', false);
  end
  coords = cellfun(@(a) a(:), coords, 'UniformOutput', false);

  points = cat(2, coords{:});
end
