function [img_] = un_imaging_domain(img, points, varargin),
  axes_provided = numel(varargin) == size(points, 2);
  
  if axes_provided % map points
    get_coords = @(d) ismember(points(:, d), varargin{d}); % Convert point to index for each dimension
    [~, coords] = arrayfun(get_coords, (1:numel(varargin)), 'UniformOutput', false);
    points = cell2mat(coords); % Gather all dimensions
  end

  img_ = accumarray(points, img, [], @median, nan);

  if axes_provided % match array to size of domain
    size_ = cellfun(@length, varargin);
    size_c = mat2cell(size_, 1, ones(1, numel(varargin)));
    if ~isequal(size(img_), size_)
      img_(size_c{:}) = 0;
    end
  end
end
