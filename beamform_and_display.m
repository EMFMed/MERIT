% Getting started guide for MERIT
% A basic guide to imaging with this toolbox.

% Load example data
load_example_data()

%% Generate imaging domain
[points, axes_] = merit.domain.hemisphere(7e-2, resolution=2.5e-3);

%% Calculate delays
% merit.get_delays returns a function that calculates the delay
%   to each point from every antenna.
delays = merit.beamform.get_delays(channel_names, antenna_locations, ...
 relative_permittivity=8);

%% Perform imaging
img = abs(merit.beamform(signals, frequencies, points, delays, ...
        merit.beamformers.DAS));

%% Display image slice
im_slice = merit.visualize.get_slice(img, points, axes_, z=35e-3);
figure()
imagesc(axes_{1:2}, im_slice);

%% Display 3D image
% Put it here