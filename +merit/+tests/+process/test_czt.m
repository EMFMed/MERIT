classdef test_czt < matlab.unittest.TestCase;
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
    reconstruction_axis_setup = struct(...
      'full', @(a) 1:numel(a), ...
      ...%'halfres1', @(a) 1:2:numel(a), ...
      ...%'halfres2', @(a) 2:2:numel(a), ...
      'lower', @(a) 1:floor(numel(a)), ...
      'arb_range', @(a) a > 5e8 & a < 8.5e9);
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
    function [] = test_max_response_fd(tc, reconstruction_axis_setup)
      fa_ = tc.fa(reconstruction_axis_setup(tc.fa));
      fd_ = merit.process.td2fd(tc.td, tc.ta, fa_);

      worst_resolution = @(varargin) max(cellfun(@max, varargin(:)));
      tc.verifyEqual(get_frequencies(tc.fa, tc.fd), get_frequencies(fa_, fd_),...
        'AbsTol', worst_resolution(tc.fa, fa_));

      function [freqs] = get_frequencies(axis_, fd)
        [~, inds] = max(fd, [], 1);
        freqs = axis_(inds);
      end
    end

    function [] = test_td_amplitude(tc, reconstruction_axis_setup)
      orig_size = size(tc.fd);
      F = reconstruction_axis_setup(tc.fa);
      fa_ = tc.fa(F);
      td_ = merit.process.fd2td(...
        reshape(tc.fd(F, :), [numel(fa_), orig_size(2:end)]),...
        fa_, tc.ta);
      
      lags = merit.utility.reshape2d(@cc, tc.td, td_);
      tc.verifyTrue(all(lags(:) == 0));

      function [best] = cc(x, y)
        for c = 1:size(x, 2)
          [xcf, lags] = crosscorr(x(:, c), y(:, c));
          [~, xcf_] = max(xcf);
          best(:, c) = lags(xcf_);
        end
      end
    end
  end
end

function [a] = n(a)
  a = bsxfun(@rdivide, a, max(a));
end
