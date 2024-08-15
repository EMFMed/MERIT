% A basic guide to loading and processing the signals

%% Load example data
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

if isvarname("example_data_loaded")
    return
end

frequencies = dlmread('example_data/frequencies.csv');
antenna_locations = dlmread('example_data/antenna_locations.csv');
channel_names = dlmread('example_data/channel_names.csv');

scan1 = dlmread('example_data/B0_P3_p000.csv');
scan2 = dlmread('example_data/B0_P3_p036.csv');

% Perform rotation subtraction
signals = scan1-scan2;

example_data_loaded = true;