% Getting started guide for MERIT
% A basic guide to imaging with this toolbox.

%{
getting_started.m demonstrates the following:
- Loading the dataset.
- Generating an empty domain.
- Calculating the delays for relavent points in the domain.
- DAS beamforming an image.
- Displaying the an image slice.
- Displaying a 3D image.
%}

%% Load example data
% Details of the breast phantoms used to collect the sample data
% are given in "Microwave Breast Imaging: experimental
% tumour phantoms for the evaluation of new breast cancer diagnosis
% systems", 2018 Biomed. Phys. Eng. Express 4 025036.
% The antenna locations, frequency points and scattered signals
% are given in the "example_data/" folder:

% frequencies.csv: a vector of frequency points in Hertz.
frequencies = dlmread('example_data/frequencies.csv');
%{
antenna_locations.csv: an array for the coordinates for each antenna relative
to the centre of the chamber, in metres.
%}
antenna_locations = dlmread('example_data/antenna_locations.csv');
%{
channel_names.csv:
- The first column is the index of antenna that sent the signal.
- The second column is the index of the antenna that received the signal.
%}
channel_names = dlmread('example_data/channel_names.csv');

%Load the signal (The size is frequencies x channel_names).
% Select the signal data from a range of different scans.
ph = "B0"; % Choose breast phantom from the following: {'B0','B10E','B15E','B20E','B30E'}.
pl = 3; % Choose tumour from list of 1 to 22.
[scan1, scan2] = load_scan(ph, pl);

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