function [inds] = txrx2ind(channels, tx, rx)
  % Generate a list on indices for selecting channels
  %
  % inds = txrx2ind(channels, tx, rx);
  %   singleton expansion is performed on tx and rx and
  %   indices is the same shape as the expanded tx and rx arrays.

  if ~exist('rx', 'var')
    rx = tx;
  else
    [tx, rx] = merit.utility.expand(tx, rx);
  end

  nChannels = size(channels, 1);

  inds = merit.utility.under(@get_inds, @(a) a(:), @(a) reshape(a, size(tx)), tx, rx);

  function [inds] = get_inds(tx, rx)
    s = [nChannels, numel(tx)];
    [inds, ~] = ind2sub(s, find(all(bsxfun(@eq, channels', permute([tx, rx], [2, 3, 1])))));
  end
end
