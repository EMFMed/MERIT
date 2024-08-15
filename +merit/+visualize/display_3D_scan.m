function display_3D_scan(grid_, options)
% Display a 3D colormap render of a (:, :, :) grid.
% The density is relative to the highest and lowest numbers.
% Higher density means higher opacity.
arguments
    % Matrix containing the data to render.
    grid_ (:, :, :) {mustBeNumeric}

    % --- Optional arguments---

    % Specify figure to display. "0" means don't specify
    options.figure_number (1, 1) {mustBeGreaterThanOrEqual(options.figure_number, 0)} ...
        = 0

    % Numbers above the 90th percentile are always set to full opacity.

    % Shift the max_opacity (between 0 and 1) for numbers between the ...
    % upper quartile and the 90th quartile.
    % ( Default is 1 ).
    options.upper_opacity (1, 1)...
        {mustBeInRange(options.upper_opacity, 0, 1, 'exclude-lower')} ...
        = 1

    % Change the factor (between 0 and 1) for the max_opacity for numbers...
    % between the lower and upper quartile, relative to upper_opacity.
    % middle_opacity = middle_opacity_factor * upper_opacity
    options.middle_opacity_factor (1, 1) ...
        {mustBeInRange(options.middle_opacity_factor, 0, 1, 'exclude-lower')} ...
        = 0.4 % Default value

    % Change the factor (between 0 and 1) for the max_opacity of...
    % numbers below the lower quartile, relative to middle_opactiy.
    % max_lower_opacity = middle_opacity * lower_opacity_factor.
    % lower_opacity = lower_opacity_factor * middle_opacity
    options.lower_opacity_factor (1, 1) ...
        {mustBeInRange(options.lower_opacity_factor, 0, 1, 'exclude-lower')} ...
        = 0.1
    
    % Specify the colormap. Can take a string or a (:, 3) matrix
    options.colormap = "jet"
end

if options.figure_number < 1
    figure;
else
    figure(options.figure_number);
end
hold on;

[lx, ly, lz] = size(grid_);

% Generate the grid
[x, y, z] = meshgrid(1:lx, 1:ly, 1:lz);

% Plot the ball using slice

hz = slice(x, y, z, grid_, [], [], 1:lz);
set(hz, 'EdgeColor', 'none');

hy = slice(x, y, z, grid_, [], 1:ly, []);
set(hy, 'EdgeColor', 'none');

hx = slice(x, y, z, grid_, 1:lx, [], []);
set(hx, 'EdgeColor', 'none');

colormap(options.colormap);
colorbar; % Show color bar to indicate density values
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
title('3D Scan Density Visualization');
view(3); % Set the view to 3D
axis tight; % Fit the axes to the data
grid on; % Turn on the grid
% Add transparency
alpha('color'); % Use color data for transparency

vector_grid = grid_(grid_ ~= 0 & ~isnan(grid_));

max_value = max(vector_grid);
min_value = min(vector_grid);

Q1 = quantile(vector_grid, 0.25);
Q3 = quantile(vector_grid, 0.75);
Q90 = quantile(vector_grid, 0.90);

% Determine the values at specific steps
v_start = min_value;
v_mid1 = Q1;
v_mid2 = Q3;
v_mid3 = Q90;
v_end = max_value;

upper_opacity = options.upper_opacity;
middle_opacity = upper_opacity * options.middle_opacity_factor;
lower_opacity = middle_opacity * options.lower_opacity_factor;


full_diff = ( v_end - v_start);
stps1 = full_diff / ( v_mid1 - v_start );
stps2 = full_diff / ( v_mid2 - v_mid1 );
stps3 = full_diff / ( v_mid3 - v_mid2 );
stps4 = full_diff / ( v_end - v_mid3 );

% Adjust alpha_map to reflect the relative differences
alpha_map = [ ...
    linspace( 0.01, lower_opacity, stps1 ) ...
    linspace( lower_opacity, middle_opacity, stps2 )  ...
    linspace( middle_opacity, upper_opacity, stps3 )  ...
    linspace( upper_opacity, 1, stps4 ) ...
    ];

% Apply the custom alpha map
alphamap(alpha_map);

axis equal;
hold off;