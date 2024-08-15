%{
This is an example script to show how one can setup a script to test the
performance of a specific function.
In this instance, "merit.process.delay()" is tested twice, the second time
using singles instead of doubles.
For more data, look at the profiler statistics from the profile function:
    https://mathworks.com/help/matlab/ref/profile.html

This script uses "merit.test.profile_this" to measure performance.
Alternatively, use "merit.test.time_this" for no performance overhead, but
only for measuring the time and no other statistics.
%}

% Create a setup function that is only ran the first time
function [signals, loaded_delays, frequencies] = setup_func()
    frequencies = dlmread('example_data/frequencies.csv');
    antenna_locations = dlmread('example_data/antenna_locations.csv');
    channel_names = dlmread('example_data/channel_names.csv');
    
    scan1 = dlmread('example_data/B0_P3_p000.csv');
    scan2 = dlmread('example_data/B0_P3_p036.csv');
    
    %% Perform rotation subtraction
    signals = scan1-scan2;

    %% Setup frequencies
    frequencies = frequencies(:);
    
    %% Shrink the number of frequencies - for better performance
    %--- Down-sample freq. Only use every "n_divide"-th element.
    n_divide = 3; % Number to divide the sample by.
    frequencies = frequencies(1:n_divide:end);
    %--- Make sure signal frequencies match
    signals = signals(1:n_divide:end, :);
    
    [points, ~] = merit.domain.hemisphere(7e-2, pixel_dim=50);
    
    delays = merit.beamform.get_delays(channel_names, antenna_locations, relative_permittivity=8);
    loaded_delays = delays(points);
end

% Only run the setup function the first time
if isvarname("first_time")
    [signals, loaded_delays, frequencies] = setup_func();
    sin_sig = single(signals);
    sin_ds = single(loaded_delays);
    sin_freq = single(frequencies);
    first_time = true;
end

%% Get performance info
info_double = merit.test.profile_this( (@() merit.process.delay(signals, loaded_delays, frequencies)) );
% Change values from doubles to singles
info_single = merit.test.profile_this( (@() merit.process.delay(sin_sig, sin_ds, sin_freq)) );

%% Display
disp(["Total time using doubles:", info_double.FunctionTable(1).TotalTime])
disp(["Total time using singles:", info_single.FunctionTable(1).TotalTime])

% Get the time difference
time_diff_perc = 100*( info_double.FunctionTable(1).TotalTime...
    - info_single.FunctionTable(1).TotalTime )...
    ./info_double.FunctionTable(1).TotalTime;

% Display difference
fprintf("\tSingles are %.2g%% faster\n", time_diff_perc);

% Show table
Name = {info_double.FunctionTable.FunctionName}';
Times_Called = [info_double.FunctionTable.NumCalls]';
Total_Time = [info_double.FunctionTable.TotalTime]'; % Includes child functions inside it.

info_table = table(Name, Times_Called, Total_Time);
disp("Table for all functions:")
disp(info_table)

% Show children for first function called:
disp("Table for children of first function:");
disp(info_double.FunctionTable(1).Children);