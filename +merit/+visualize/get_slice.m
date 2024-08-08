function [grid_] = get_slice(img, points, axes_, options)
  % slice = get_slice(img, points, axes_, 'z', 0.05);
  % Returns a slice of the image at z location 5 cm.
   
  arguments
      img 
      points 
      axes_ 
      options.z = 0 
  end

  isequaltol = @(a, b) abs(a-b)<1e-6;
  P = isequaltol(points(:, 3), options.z);

  grid_ = merit.domain.img2grid(img(P), points(P, :), axes_{1:2}, options.z);
end
