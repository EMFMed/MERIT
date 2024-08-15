% A basic guide to loading and visualising the sample data;

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
ph = "B0"; % Choose breast phantom from the following: {'B0','B10E','B15E','B20E','B30E'}.
pl = 3; % Choose tumour from list of 1 to 22.
[scan1, scan2] = load_scan(ph, pl);

% Perform rotation subtraction
signals = scan1-scan2;

%% Plot the acquired scans.
figure()
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

%% Plot artefact removed: channel 1
figure()
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