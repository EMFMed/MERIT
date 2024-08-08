classdef test_beamform < matlab.unittest.TestCase;
  properties
  end

  properties (TestParameter)
  end
  methods(TestClassSetup)
    function [] = setupOnce(testCase)
    end
  end

  methods (Test)
    function [] = test_basic(testCase),
      location = [0, 15e-3]; % theta, rho

      [data, frequencies, channels, antenna_locations] = get_data();
      [points, axes_] = merit.domain.hemisphere(radius=7e-2, resolution=2.5e-3);

      time_axis = (0:599)'/80e9;
      [pulse_td, pulse_fd] = DG(3e9, 1/3e9, time_axis, frequencies);
      signals = single(merit.process.shape(data, pulse_fd, frequencies, time_axis));

      delay_func = merit.beamform.get_delays(channels, antenna_locations, relative_permittivity=8);

      img = merit.beamform(signals, time_axis, points, delay_func, merit.beamformers.DAS, window= merit.beamform.windows.rectangular(150));
      [~, i] = max(img);
      [t, r, z] = cart2pol(points(i, 1), points(i, 2), points(i, 3));

      grid_img = merit.domain.img2grid(img, points, axes_{:});
      testCase.verifyLessThan(abs(rad2deg(t)-location(1)), 9);
      testCase.verifyLessThan(abs(r-location(2)), 5e-3);
    end

    function [] = test_basic_fd(testCase),
      location = [0, 15e-3]; % theta, rho
      [data, frequencies, channels, antenna_locations] = get_data();
      [points, axes_] = merit.domain.hemisphere(radius=7e-2, resolution=2.5e-3);

      F = frequencies >= 2e9 & frequencies <= 4e9;
      data = single(data(F, :));
      frequencies = frequencies(F);

      delay_func = merit.beamform.get_delays(channels, antenna_locations, relative_permittivity=8);

      img = abs(merit.beamform(data, frequencies, points, delay_func, merit.beamformers.DAS));
      [~, i] = max(img);
      [t, r, z] = cart2pol(points(i, 1), points(i, 2), points(i, 3));
      testCase.verifyLessThan(abs(rad2deg(t)-location(1)), 9);
      testCase.verifyLessThan(abs(r-location(2)), 7e-3);
    end
  end
end

function [pulse, pulse_fd] = DG(freq, tau, time_axis, freq_axis)
  tp = 2.5*tau;
  pulse = sin(2*pi*freq*time_axis).*exp(-((time_axis-tp)./tau).^2);
  if nargout > 1
    pulse_fd = merit.process.td2fd(pulse, time_axis, freq_axis);
  end
end

function [fd, fa, chs, ants] = get_data()
  scan1 = dlmread('example_data/B0_P3_p000.csv');
  scan2 = dlmread('example_data/B0_P3_p036.csv');
  fd = scan1-scan2;
  fa = dlmread('example_data/frequencies.csv');
  chs = dlmread('example_data/channel_names.csv');
  ants = dlmread('example_data/antenna_locations.csv');
end
