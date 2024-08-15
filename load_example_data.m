% A basic guide to loading and processing the signals



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