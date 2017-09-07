function [signals_] = fd2td(signals, frequency_axis, time_axis)
  % merit.process.fd2td converts signals from the frequency domain to the time domain
  %   using the inverse Chirp-Z transform (using the MATLAB Chirp-Z transform implementation).
  %
  % signals = merit.process.fd2td(signals, frequency_axis, time_axis);
  %   signals: N_f x C x ... array
  %   signals_: N_t x C x ... array
  %   where:
  %     N_f is the number of frequency samples
  %     N_t is the number of time samples
  %     C is the number of channels
  %     frequency_axis is the set of frequency samples
  %     time_axis is the set of time samples

  %% Input validation
  validateattributes(signals, {'numeric'},...
    {'nrows', numel(frequency_axis)});
  validateattributes(frequency_axis, {'numeric'},...
    {'vector', 'increasing', 'real'});
  validateattributes(time_axis, {'numeric'},...
    {'vector', 'increasing', 'real'});

  if ~merit.utility.linearlysampled(time_axis)
    error('merit:process:fd2td', 'Time axis needs to be linearly sampled');
  end
  if ~merit.utility.linearlysampled(frequency_axis)
    error('merit:process:fd2td', 'Frequency axis needs to be linearly sampled');
  end

  %% Accommodate trailing dimensions
  signals_ = merit.utility.reshape2d(@fd2td_, signals);

  function [signals_] = fd2td_(signals)
    time_axis = time_axis(time_axis >= 0);
    dt = diff(time_axis(1:2));
    df = diff(frequency_axis(1:2));

    % Compute iczt transform using forward czt by applying conjugation
    m = numel(time_axis);
    w = exp(-1j*2*pi*dt*df);
    a = exp(1j*2*pi*min(time_axis(:))*df);

    iczt = @(z) merit.utility.under(@(z) czt(z, m, w, a), @conj, @conj, z);

    % Phase compensation
    phase = exp(1j*2*pi*min(frequency_axis(:)).*time_axis(:));
    phase_compensation = @(z) real(bsxfun(@times, phase(:), z))/m;

    signals_ = phase_compensation(iczt(signals));
  end
end

