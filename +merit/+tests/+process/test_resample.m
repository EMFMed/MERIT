classdef test_resample < matlab.unittest.TestCase;
  properties
  end
  methods(TestClassSetup)
    function [] = setupOnce(tc)
    end
  end

  methods(TestClassTeardown)
    function [] = tearDownOnce(tc)
    end
  end

  methods (TestMethodSetup)
    function [] = setup(tc)
    end
  end

  methods(TestMethodTeardown)
    function [] = teardown(tc)
    end
  end

  methods (Test)
    function [] = test_sinewave(tc),
      from_frequency = 5.9958e11;
      to_frequency = 5e10;
      nChannels = 100;
      nTimeSteps = 5000;
      sine_freqs = linspace(1e9, 10e9, nChannels);
      time_axis = (0:nTimeSteps-1)/from_frequency;
      for f = 1:numel(sine_freqs),
        sigs(:, f) = sin(2*pi*time_axis*sine_freqs(f));
      end

      down = merit.process.resample(sigs, from_frequency, to_frequency);

      [orig_max] = get_max_frequency(sigs, from_frequency);
      [new_max] = get_max_frequency(down, to_frequency);

      max_errors = [max(abs(sine_freqs-orig_max)), max(abs(sine_freqs-new_max))];
      max_frequency_resolution = max([from_frequency, to_frequency]/nTimeSteps);

      tc.verifyLessThan(max_errors, max_frequency_resolution);

      function [maxf] = get_max_frequency(sigs, sampling_frequency),
        y = fft(sigs);
        f = (0:size(y, 1)-1)*sampling_frequency/size(y, 1);
        [~, index] = max(y(1:floor(end/2), :));
        maxf = f(index);
      end
    end
  end
end
