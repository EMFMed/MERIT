function [signals, actual_frequency] = resample(signals, from_frequency, to_frequency)
  % Resample signals from a given frequency to a given frequency
  %
  % [new_signals, actual_frequency] = resample(signals, from_frequency, to_frequency)
  % where:
  %   signals is the NxM array containing N time steps and M channels
  %   from_frequency and to_frequency are in Hz.
  %
  % new_signals are the resampled signals, and as this is a thin wrapper around MATLAB's
  % rat and resample, actual_frequency is the exact frequency it is resampled to.
  % Given the defaults to rat, the rational approximation to to_frequency/from_frequency
  % should be within 10^-6 from the actual ratio.

  [P, Q] = rat(to_frequency/from_frequency);
  actual_frequency = P*from_frequency;

  signals = resample(signals, P, Q);
end
