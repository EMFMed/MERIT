function [signals_] = td2fd(signals, time_axis, frequency_axis)
  % merit.process.td2fd converts signals from the time domain to the frequency domain
  %   using the Chirp-Z transform (MATLAB implementation).
  %
  % signals = merit.process.td2fd(signals, time_axis, frequency_axis);
  %   signals: N_t x C x ... array
  %   signals_: N_f x C x ... array
  %   where:
  %     N_t is the number of time samples
  %     N_f is the number of frequency samples
  %     C is the number of channels
  %     time_axis is the set of time samples
  %     frequency_axis is the set of frequency samples

  %% Input validation
  validateattributes(signals, {'numeric'},...
    {'nrows', numel(time_axis), 'real'});
  validateattributes(time_axis, {'numeric'},...
    {'vector', 'increasing', 'real'});
  validateattributes(frequency_axis, {'numeric'},...
    {'vector', 'increasing', 'real'});

  if ~merit.utility.linearlysampled(time_axis)
    error('merit:process:td2fd', 'Time axis needs to be linearly sampled');
  end
  if ~merit.utility.linearlysampled(frequency_axis)
    error('merit:process:td2fd', 'Frequency axis needs to be linearly sampled');
  end

  %% Accommodate trailing dimensions
  signals_ = merit.utility.reshape2d(@td2fd_, signals);

  function [signals_] = td2fd_(signals)
    dt = diff(time_axis(1:2));
    df = diff(frequency_axis(1:2));

    m = numel(frequency_axis);
    w = exp(-1j*2*pi*df*dt);
    a = exp(1j*2*pi*min(frequency_axis)*dt);

    signals_ = czt(signals, m, w, a);
  end
end
