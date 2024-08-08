frequencies = dlmread('example_data/frequ'example_data/encies.csv');
antenna_locations = dlmread('example_data/antenna_locations.csv');
channel_names = dlmread('example_data/channel_names.csv');

scan_B0_P3_1 = dlmread('example_data/B0_P3_p000.csv');
scan_B0_P3_2 = dlmread('example_data/B0_P3_p036.csv');
scan_B0_P5_1 = dlmread('example_data/B0_P5_p000.csv');
scan_B0_P5_2 = dlmread('example_data/B0_P5_p036.csv');

B0_P3 = scan_B0_P3_1 - scan_B0_P3_2;
B0_P5 = scan_B0_P5_1 - scan_B0_P5_2;

[points, axes_] = merit.domain.hemisphere(radius=7e-2, resolution=2.5e-3);

delays_B0 = merit.beamform.get_delays(channel_names, antenna_locations, ...
  relative_permittivity=8);

%% Perform imaging
img_P3 = abs(merit.beamform(B0_P3, frequencies, points, delays_B0, ...
        merit.beamformers.DAS));
img_P5 = abs(merit.beamform(B0_P5, frequencies, points, delays_B0, ...
        merit.beamformers.DAS));

im_slice_P3 = merit.visualize.get_slice(img_P3, points, axes_, z=35e-3);
im_slice_P5 = merit.visualize.get_slice(img_P5, points, axes_, z=35e-3);

subplot(2, 1, 1);
imagesc(axes_{1:2}, im_slice_P3);
subplot(2, 1, 2);
imagesc(axes_{1:2}, im_slice_P5);
