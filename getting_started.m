% Getting started guide for MERIT
% A basic guide to:
%  - loading and visualising the sample data;
%  - processing signals using the MERIT functions;
%  - imaging with this toolbox.

%% Loading sample data
% Details of the breast phantoms used to collect the sample data
% are given in "Microwave Breast Imaging: experimental
% tumour phantoms for the evaluation of new breast cancer diagnosis
% systems", 2018 Biomed. Phys. Eng. Express 4 025036.
% The antenna locations, frequency points and scattered signals
% are given in the /data folder:
%   antenna_locations.csv: the antenna locations in metres;
%   frequencies.csv: the frequency points in Hertz;
%   channel_names.csv: the descriptions of the channels in the scattered data;
%   B0_P3_p000.csv: homogeneous breast phantom with an 11 mm diameter
%     tumour located at (15, 0, 35) mm.
%   B0_P5_p000.csv: homogeneous breast phantom with an 20 mm diameter
%     tumour located at (15, 0, 30) mm.
% For both phantoms, a second scan rotated by 36 degrees from the first
% was acquired for artefact removal:
% B0_P3_p036.csv and B0_P5_p036.csv respectively.

frequencies = dlmread('data/frequencies.csv');
antenna_locations = dlmread('data/antenna_locations.csv');
channel_names = dlmread('data/channel_names.csv');

scan1 = dlmread('data/B0_P3_p000.csv');
scan2 = dlmread('data/B0_P3_p036.csv');

%% Plot the acquired scans.
data_channel1 = [scan1(:, 1), scan2(:, 1)];
channel1_magnitude = mag2db(abs(data_channel1));
channel1_phase = unwrap(angle(data_channel1));
subplot(2, 1, 1);
plot(frequencies, channel1_magnitude);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
legend('Original Scan', 'Rotated Scan');
title(sprintf('Channel (%d, %d) Magnitude', channel_names(1, :)));
subplot(2, 1, 2);
plot(frequencies, channel1_phase);
xlabel('Frequency (Hz)');
ylabel('Phase (rad)');
legend('Original Scan', 'Rotated Scan');
title(sprintf('Channel (%d, %d) Phase', channel_names(1, :)));


%% Perform rotation subtraction
signals = scan1-scan2;

%% Plot artefact removed: channel 1
rotated_channel1_magnitude = mag2db(abs(signals(:, 1)));
rotated_channel1_phase = unwrap(angle(signals(:, 1)));
subplot(2, 1, 1);
plot(frequencies, [channel1_magnitude, rotated_channel1_magnitude]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
legend('Original Scan', 'Rotated Scan', 'Artefact removed');
title(sprintf('Channel (%d, %d) Magnitude—Artefact removed', channel_names(1, :)));
subplot(2, 1, 2);
plot(frequencies, [channel1_phase, rotated_channel1_phase]);
xlabel('Frequency (Hz)');
ylabel('Phase (rad)');
legend('Original Scan', 'Rotated Scan', 'Artefact removed');
title(sprintf('Channel (%d, %d) Phase—Artefact removed', channel_names(1, :)));

%% Generate imaging domain and visualise
[points, axes_] = merit.domain.hemisphere('radius', 7e-2, 'resolution', 2.5e-3);
subplot(1, 1, 1);
scatter3(points(:, 1), points(:, 2), points(:, 3), '+');

%% Calculate delays
% merit.get_delays returns a function that calculates the delay
%   to each point from every antenna.
delays = merit.beamform.get_delays(channel_names, antenna_locations, ...
  'relative_permittivity', 8);

%% Perform imaging
img = abs(merit.beamform(signals, frequencies, points, delays, ...
        merit.beamformers.DAS));

%% Convert to grid for image display
%grid_ = merit.domain.img2grid(img, points, axes_{:});

im_slice = merit.visualize.get_slice(img, points, axes_, 'z', 35e-3);
imagesc(axes_{1:2}, im_slice);
