classdef test_delay < matlab.unittest.TestCase;
  %% Compare to fft

  properties
    ta
    fa
    td
    fd
  end

  properties(ClassSetupParameter)
    nChannels = struct(...
      'oned', [11], ...
      'twod', [11, 11]);
    sampling_frequency = {40e9, 80e9, 500e9};
    signal = struct(...
      'sine', @(ta, fs) sin(2*pi*bsxfun(@times, ta, fs)));
  end

  properties(TestParameter)
    delay = {0, 10, -10, 20, -20};
  end

  methods(TestClassSetup)
    function [] = setup(tc, nChannels, sampling_frequency, signal)
      nTimeSteps = floor(10e-9*sampling_frequency);
      frequencies = linspace(1e9, 8e9, prod(nChannels));
      get_time_axis = @(ns, fs) (0:ns-1)'/fs;

      tc.ta = get_time_axis(nTimeSteps, sampling_frequency);
      tc.fa = (sampling_frequency*(0:nTimeSteps/2)/nTimeSteps)';

      td = signal(tc.ta(:), frequencies);

      fd = fft(td);
      fd = fd(1:nTimeSteps/2+1, :);
      tc.td = reshape(td, [size(td, 1), nChannels]);
      tc.fd = reshape(fd, [size(fd, 1), nChannels]);
    end
  end

  methods (Test)
    function [] = test_reversible(tc, delay)
      delay_td = @(s, d) merit.process.delay(s, d);
      delay_fd = @(s, d) merit.process.delay(s, d, tc.fa);

      inverted_td = delay_td(delay_td(tc.td, delay), -delay);
      inverted_fd = delay_fd(delay_fd(tc.fd, delay), -delay);

      preserved_time_td = ~isnan(inverted_td);

      tc.verifyEqual(tc.td(preserved_time_td), inverted_td(preserved_time_td));
      tc.verifyEqual(tc.fd, inverted_fd, 'RelTol', 1e-6);
    end

    function [] = test_allmissing(tc)
      td_ = merit.process.delay(tc.td, numel(tc.ta));
      tc.verifyTrue(all(isnan(td_(:))));

      td__ = merit.process.delay(tc.td, -numel(tc.ta));
      tc.verifyTrue(all(isnan(td__(:))));
    end

    function [] = leave_one(tc)
      td_ = merit.process.delay(tc.td, 1-numel(tc.ta));
      tc.verifyTrue(all(all(isnan(td_(2:end, :)))));
      tc.verifyEqual(tc.td(end, :), td_(1, :));

      td__ = merit.process.delay(tc.td, numel(tc.ta)-1);
      tc.verifyTrue(all(all(isnan(td__(1:end-1, 1)))));
      tc.verifyEqual(tc.td(1, :), td__(end, :));
    end
  end
end
