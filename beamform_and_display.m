% Getting started guide for MERIT
% A basic guide to imaging with this toolbox.

%% Load example data
% Details of the breast phantoms used to collect the sample data
% are given in "Microwave Breast Imaging: experimental
% tumour phantoms for the evaluation of new breast cancer diagnosis
% systems", 2018 Biomed. Phys. Eng. Express 4 025036.
% The antenna locations, frequency points and scattered signals
% are given in the "example_data/" folder:

% frequencies.csv: the frequency points in Hertz;
frequencies = dlmread('example_data/frequencies.csv');
% antenna_locations.csv: the antenna locations in metres;
antenna_locations = dlmread('example_data/antenna_locations.csv');
% channel_names.csv: the descriptions of the channels in the scattered data;
channel_names = dlmread('example_data/channel_names.csv');

% Select the signal data from a range of different scans.
% TODO: Replace this with the BRIGID function that explains what each one
% does.
scan1 = dlmread('example_data/B0_P3_p000.csv');
% For a second scan rotated by 36 degrees from the first
% was acquired for artefact removal:
scan2 = dlmread('example_data/B0_P3_p036.csv');

% Perform rotation subtraction
signals = scan1-scan2;

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
grid_ = merit.domain.img2grid(img, points, axes_{:});
merit.visualize.display_3D_scan(grid_);