function [f] = G_GSS(imgs, points, axes_),
  %merit.beamform.un_imaging_domain(img, points, axes_)
  window_size = 15;
  nPoints = size(points, 1);

  inds = (1:nPoints)';
  grid_ = merit.beamform.un_imaging_domain(inds, points, axes_{:});
  if isa(imgs, 'single')
    grid_ = single(grid_);
  end
  [Gx, Gy, Gz] = get_filter(window_size);

  block_starts = size(grid_) - size(Gx) + [1, 1, 1];
  nBlocks = prod(block_starts);
  blocks = zeros(numel(Gx), nBlocks, class(imgs));

  flatten = @(a) a(:);
  get_block = @(a, x, y, z, w) flatten(a(x+w, y+w, z+w));
  for b = 1:nBlocks
    [x, y, z] = ind2sub(block_starts, b);
    blocks(:, b) = get_block(grid_, x, y, z, 0:window_size-1);
  end
  blocks(:, any(isnan(blocks))) = [];

  f = zeros(1, size(imgs, 2), 'like', imgs);
  for i = 1:size(imgs, 2)
    img_ = imgs(:, i);
    f(i) = mean(sum(sum(img_(blocks).*cat(3, Gx(:), Gy(:), Gz(:)), 1).^2, 3), 2);
  end
end

function [Gx, Gy, Gz] = get_filter(window_size)
  N = floor(window_size/2);
  sig = N/2.5;
  [x,y,z] = meshgrid(-N:N, -N:N, -N:N);
  G = exp(-(x.^2+y.^2+z.^2)/(2*sig^2))/(2*pi*sig);

  normalise = @(a) a./sum(a(:));
  Gx = normalise(-x.*G/(sig^2));
  Gy = normalise(-y.*G/(sig^2));
  Gz = normalise(-z.*G/(sig^2));
end
