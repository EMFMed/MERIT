% A basic guide to loading and visualising the sample data;

% Load example data
load_example_data()

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