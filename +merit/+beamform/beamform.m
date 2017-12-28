function [img, sigs] = beamform(signals, axis_, points, delay, window, image_, varargin),
  p = inputParser;
  addOptional(p, 'max_memory', 1e9, @isnumeric);
  addOptional(p, 'gpu', false, @islogical);
  parse(p, varargin{:});
  gpu = p.Results.gpu;
  max_memory = p.Results.max_memory;

  if isreal(signals),
    bytes = 8;
  else
    bytes = 16;
  end

  if gpu,
    try
      dev = gpuDevice();
      free_mem = dev.FreeMemory;
      if free_mem > numel(signals)*bytes
        max_memory = dev.FreeMemory/4;
        signals = gpuArray(signals);
        points = gpuArray(points);
      else
        gpu = false;
      end
    catch
      gpu = false;
    end
  end

  max_points = @(mem) floor(mem/numel(signals)/bytes);

  nPoints = size(points, 1);
  points_per_range = max_points(max_memory);

  ranges = [repmat(points_per_range, [1, floor(nPoints/points_per_range)]), rem(nPoints, points_per_range)];
  ranges_ = mat2cell(1:size(points, 1), 1, ranges);

  img = zeros(size(points, 1), 1, 'like', signals);
  for r = 1:numel(ranges_),
    img(ranges_{r}) = image_(window(...
      merit.process.delay(signals, delay(points(ranges_{r}, :)), axis_)));
  end

  if gpu
    img = gather(img);
    dev = gpuDevice();
    reset(dev);
  end
end
