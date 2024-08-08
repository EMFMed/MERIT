function [img_] = img2grid(img, points, varargin)
  axes_provided = numel(varargin) == size(points, 2);
  
  if axes_provided % map points
    get_coords = @(d) ismembertol(points(:, d), varargin{d}, 1e-6); % Convert point to index for each dimension
    [~, coords] = arrayfun(get_coords, (1:numel(varargin)), 'UniformOutput', false);
    points = cell2mat(coords); % Gather all dimensions
  end

  img_ = accumarray(points, img, [], [], nan('like', img));

  if axes_provided % match array to size of domain
    size_ = cellfun(@length, varargin);
    size_c = mat2cell(size_, 1, ones(1, numel(varargin)));
    if ~isequal(size(img_), size_)
      img__ = nan(size_c{:});
      old_axes = arrayfun(@(a) 1:a, size(img_), 'UniformOutput', false);
      img__(old_axes{:}) = img_;
      img_ = img__;
    end
  end
end
