function [smr] = SMR(img, points, varargin),
  switch numel(varargin)
    case {1, 4}
      loc = varargin{1};
    otherwise
      [~, mx] = max(img);
      loc = points(mx, :);
  end

  [f(1), f(2), f(3)] = merit.metrics.FWHM(img, points, varargin{:});
  tumour = sum(((points - loc)./f).^2, 2) <= 1;

  smr = 10*log10(max(img(tumour))./mean(img));
end
