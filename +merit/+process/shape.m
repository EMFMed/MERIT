function [signals] = shape(fd, pulse, frequency_axis, time_axis)
  % Shape channel response by a pulse and convert to the time domain
  %
  % td = merit.process.shape(fd, pulse, frequency_axis, time_axis);

  %% Input validation
  validateattributes(fd, {'numeric'},...
    {'nrows', numel(frequency_axis)});
  validateattributes(pulse, {'numeric'},...
    {'vector', 'numel', numel(frequency_axis)});

  signals = merit.process.fd2td(bsxfun(@times, fd, pulse(:)), frequency_axis, time_axis);
end
