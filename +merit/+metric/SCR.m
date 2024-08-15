function [scr, next] = SCR(img, points, varargin),
  switch numel(varargin)
    case {1, 4}
      loc = varargin{1};
    otherwise
      [~, mx] = max(img);
      loc = points(mx, :);
  end

  [f(1), f(2), f(3)] = merit.metrics.FWHM(img, points, varargin{:});
  tumour = sum(((points - loc)./f).^2, 2) <= 1;

  if sum(~tumour) > 0
    tmax = max(img(tumour));
    [cmax, cind] = max(img(~tumour));
    scr = 10*log10(tmax./cmax);
    points_ = points(~tumour, :);
    next = points_(cind, :);
  else
    scr = 0;
    next = loc;
  end
end
