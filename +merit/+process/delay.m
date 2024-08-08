function [signals_] = delay(signals, delays, axis_, padding)
  % delay signals (in time or frequency domain) by delays.
  %
  % td_ = merit.process.delay(td, delays);
  %   td: must be real
  %   delays: 1 x C x ... array of sample delays
  %     will be expanded to the number of dimensions of td
  %
  % signals_ = merit.process.delay(signals, delays, axis);
  %   if signals is real:
  %     signals are the time domain signals
  %     delays: in seconds
  %     axis: must match first dimension of signals, provides sampling information
  %   else signals are complex:
  %     signals are in the frequency domain
  %     delays: in seconds
  %     axis: match the first dimension of signals, frequency of each point.

  if ~exist('padding', 'var')
    padding = @nan;
  end
  [signals, delays] = merit.utility.expand2(signals, delays);

  if isreal(signals)
    %% Time domain
    if nargin == 2
      %% time domain, delay in samples
      validateattributes(delays, {'numeric'}, {'integer'});
      signals_ = merit.utility.reshape2d(@delay_sample, signals, delays);
    elseif nargin >= 3 & numel(axis_) == size(signals, 1)
      %% Time axis provided
      validateattributes(axis_, {'numeric'},...
        {'vector', 'increasing', 'real'});
      if ~merit.utility.linearlysampled(axis_)
        error('merit:process:delay', 'Time axis needs to be linearly sampled');
      end
      dt = diff(axis_(1:2));
      signals_ = merit.utility.reshape2d(@delay_sample, signals, round(delays./dt));
    elseif nargin == 3 & isa(axis_, 'function_handle')
      % Padding provided
      padding = axis_;
      validateattributes(delays, {'numeric'}, {'integer'});
      signals_ = merit.utility.reshape2d(@delay_sample, signals, delays);
    end
  elseif ~isreal(signals) && nargin == 3
    %% Frequency domain
    signals_ = signals .* exp(-2i*pi*( delays .* axis_(:) ) );
  else
    signals_ = signals;
  end

  function [signals_] = delay_sample(signals, delays)
    signals_ = padding(size(signals), 'like', signals);
    signals_(:, delays==0) = signals(:, delays==0);

    for d = unique(delays(:))'
      cs = delays == d;
      if d > 0
        signals_(d+1:end, cs) = signals(1:end-d, cs);
      else
        signals_(1:end+d,cs) = signals(1-d:end, cs);
      end
    end
  end
end
