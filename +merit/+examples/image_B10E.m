frequencies = dlmread('example_data/frequencies.csv');
antenna_locations = dlmread('example_data/antenna_locations.csv');
channel_names = dlmread('example_data/channel_names.csv');

scan_B10E_P3_1 = dlmread('example_data/B10E_P3_p000.csv');
scan_B10E_P3_2 = dlmread('example_data/B10E_P3_p036.csv');
scan_B10E_P5_1 = dlmread('example_data/B10E_P5_p000.csv');
scan_B10E_P5_2 = dlmread('example_data/B10E_P5_p036.csv');

B10E_P3 = scan_B10E_P3_1 - scan_B10E_P3_2;
B10E_P5 = scan_B10E_P5_1 - scan_B10E_P5_2;

[points, axes_] = merit.domain.hemisphere(radius=7e-2, resolution=2.5e-3);

F = frequencies >= 2e9 & frequencies <= 4e9;

delays_B10E = merit.beamform.get_delays(channel_names, antenna_locations, ...
  relative_permittivity=9.75);

%% Perform imaging
img_P3 = abs(merit.beamform(B10E_P3(F, :), frequencies(F), points, delays_B10E, ...
        merit.beamformers.DAS));
img_P5 = abs(merit.beamform(B10E_P5(F, :), frequencies(F), points, delays_B10E, ...
        merit.beamformers.DAS));

[~, max_P3] = max(img_P3);
im_slice_P3 = merit.visualize.get_slice(img_P3, points, axes_, z=points(max_P3, 3));
[~, max_P5] = max(img_P5);
im_slice_P5 = merit.visualize.get_slice(img_P5, points, axes_, z=points(max_P5, 3));

subplot(2, 1, 1);
imagesc(axes_{1:2}, im_slice_P3);
subplot(2, 1, 2);
imagesc(axes_{1:2}, im_slice_P5);
