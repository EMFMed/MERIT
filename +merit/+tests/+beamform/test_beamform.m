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
      location = [0, 35e-3]; % theta, rho
      load('data/ideal_at0.mat', 'data', 'frequencies', 'channels');
      antenna_locations = get_antenna_locations();
      [points, axes_] = get_points(5e-3);

      time_axis = (0:599)'/80e9;
      [pulse_td, pulse_fd] = DG(3e9, 1/3e9, time_axis, frequencies);
      signals = merit.process.shape(data, pulse_fd, frequencies, time_axis);

      delay_func = merit.beamform.delays.per_point(channels, antenna_locations, 'relative_permittivity', 6);

      img = merit.beamform.beamform(signals, time_axis, points, delay_func, merit.beamform.windows.rectangular(150), merit.beamform.beamformers.DAS);
      [~, i] = max(img);
      [t, r, z] = cart2pol(points(i, 1), points(i, 2), points(i, 3));

      [t, r, z]
      grid_img = merit.beamform.un_imaging_domain(img, points, axes_{:});
      size(grid_img)
      imagesc(grid_img(:, :, 8))
      return
      testCase.verifyTrue(abs(rad2deg(t)-location(1)) <= 9); % Angle within 9 degrees
      testCase.verifyTrue(r-location(2) < 5e-3); % Radius within 5 mm

      grid_img = beamform.un_imaging_domain(img, points, axes_{:});
    end

    function [] = test_basic_fd(testCase),
      %{
      location = [0, 35e-3]; % theta, rho
      load('data/ideal_at0.mat', 'data', 'frequencies', 'channels');
      antenna_locations = get_antenna_locations();
      [points, axes_] = get_points(2e-3);

      F = frequencies >= 2e9 & frequencies <= 4e9;
      data = data(F, :);
      frequencies = frequencies(F);

      c_0 = 299792458;
      calculate_delay = beamform.delay(channels, antenna_locations, beamform.delays.constant(c_0/sqrt(6)));

      img = beamform.beamform(data, points, calculate_delay, beamform.windows.phase_shift(frequencies), beamform.beamformers.DAS, 'gpu', true);
      [~, i] = max(img);
      [t, r, z] = cart2pol(points(i, 1), points(i, 2), points(i, 3));
      testCase.verifyTrue(abs(rad2deg(t)-location(1)) <= 9); % Angle within 9 degrees
      testCase.verifyTrue(r-location(2) < 5e-3); % Radius within 5 mm

      grid_img = beamform.un_imaging_domain(img, points, axes_{:});
      %}
    end
  end
end

function [points_3d] = get_antenna_locations()
  elevations = [9, 32, 55];
  offsets = [0, 18, 12];

  r = 7e-2;

  elevations_ = [repmat(elevations(1), [1, 10]), repmat(elevations(2), [1, 10]), repmat(elevations(3), [1,4])];
  thetas = [(0:9)*36, (0:9)*36+18, (0:3)*90+12];
  radii = cosd(elevations_)*r;
  zs = sind(elevations_)*r;
  
  [xs, ys, zs] = pol2cart(deg2rad(thetas), radii, zs);
  points_3d = [xs(:), ys(:), zs(:)];
end

function [points, axes_] = get_points(resolution)
  radius = 70e-3;
  radius_ = radius+5e-3;

  axes_ = {(-radius_:resolution:radius_), (-radius_:resolution:radius_), (0:resolution:radius_)};
  [Xs, Ys, Zs] = ndgrid(axes_{:});
  area_ = Xs.^2 + Ys.^2+Zs.^2 <= radius.^2;
  points = merit.beamform.imaging_domain(area_, axes_{:});
end

function [pulse, pulse_fd] = DG(freq, tau, time_axis, freq_axis)
  tp = 2.5*tau;
  pulse = sin(2*pi*freq*time_axis).*exp(-((time_axis-tp)./tau).^2);
  if nargout > 1
    pulse_fd = merit.process.td2fd(pulse, time_axis, freq_axis);
  end
end
