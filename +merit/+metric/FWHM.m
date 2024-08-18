function [w_x, w_y, w_z] = FWHM(img, points, varargin),
  switch numel(varargin)
    case {1, 4}
      loc = varargin{1};
    otherwise
      [~, mx] = max(img);
      loc = points(mx, :);
  end
  switch numel(varargin)
    case 3
      axes_ = varargin;
    case 4
      axes_ = varargin(2:end);
    otherwise
      axes_ = {};
  end

  [X, Y, Z] = get_axes(points, loc);

  w_x = fwhm(img(X));
  w_y = fwhm(img(Y));
  w_z = fwhm(img(Z));

  if numel(axes_) == 3
    w_x = w_x.* diff(axes_{1}(1:2));
    w_y = w_y.* diff(axes_{2}(1:2));
    w_z = w_z.* diff(axes_{3}(1:2));
  end

  if nargout == 1
    w_x = mean([w_x, w_y, w_z]);
  end
end

function [w] = fwhm(sig),
  [m, i] = max(sig);
  less_half = find(sig < m/2);
  closest = less_half - i;
  upper = min(closest(closest >= 0));
  lower = max(closest(closest < 0));
  if isempty(upper),
    upper = numel(sig) - i + 1;
  end
  if isempty(lower),
    lower = -i;
  end
  w = upper-lower-1;
end

function [X, Y, Z] = get_axes(ps, l)
  X = find(tol(ps(:, 2), l(2)) & tol(ps(:, 3), l(3)));
  [~, X_] = sort(ps(X, 1));
  X = X(X_);

  Y = find(tol(ps(:, 1), l(1)) & tol(ps(:, 3), l(3)));
  [~, Y_] = sort(ps(Y, 2));
  Y = Y(Y_);

  Z = find(tol(ps(:, 1), l(1)) & tol(ps(:, 2), l(2)));
  [~, Z_] = sort(ps(Z, 3));
  Z = Z(Z_);
end

function [a] = tol(a, p)
  a = abs(a - p) < 1e-6;
end
