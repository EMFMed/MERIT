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
  if isa(signals, 'single')
    bytes = bytes/2;
    axis_ = single(axis_);
    points = single(points);
  end

  if ~iscell(delay)
    delay = {delay};
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
  points_run = max_points(max_memory);

  img = zeros([nPoints, numel(delay), size_t(signals)], 'like', signals);

  for r = 1:points_run:nPoints,
    for d = 1:numel(delay)
      rng = r:min(nPoints, r+points_run-1);
      img(rng, d, :) = image_(window(...
        merit.process.delay(signals, delay{d}(points(rng, :)), axis_)));
    end
  end

  if gpu
    img = gather(img);
    dev = gpuDevice();
    reset(dev);
  end
end

function [s] = size_t(a)
  s = size(a);
  if numel(s) <= 2
    s = [s, 1];
  end
  s = s(3:end);
end
