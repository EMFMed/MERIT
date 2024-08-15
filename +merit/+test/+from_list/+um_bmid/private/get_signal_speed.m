function prop_speed = get_signal_speed(ant_phase_rad, adi_rad, options)
% 1x1
% Returns the relative speed of the signal, adjusted for the permittivities
% of the air and the breast model.
arguments
    % The distance from the antenna's phase centre to the chamber centre, 
    ant_phase_rad (1, 1) {mustBeGreaterThanOrEqual(ant_phase_rad, 0)}
    % The radius of the adipose
    adi_rad (1, 1) {mustBeGreaterThanOrEqual(adi_rad, 0)}

    % --- Optional arguments---
    % The adipose 2D coords
    options.adi_coords (1, 2) {mustBeNumeric} = [0, 0]
    % The tumor radius
    options.tum_rad (1, 1) {mustBeGreaterThanOrEqual(options.tum_rad, 0)} = 0
    % The tumor 2D coords
    options.tum_coords (1, 2) {mustBeNumeric} = [0, 0]
    % Number of pixels for each side. Higher means more resolution at the cost of performance.
    options.m_size (1, 1) {mustBeGreaterThanOrEqual(options.m_size , 1)} = 500

    % Permittivity:
    options.vacuum_speed (1, 1) {mustBeNumeric} = 3e8;
    options.air_permittivity (1, 1) {mustBeNumeric} = 1;
    options.adi_permittivity (1, 1) {mustBeNumeric} = 7.08;
    options.tum_permittivity (1, 1) {mustBeNumeric} = 77.11;
    options.skin_permittivity (1, 1) {mustBeNumeric} = 40;
    options.skin_thickness (1, 1) {mustBeNumeric} = 0;
end
%% Assign options
tum_x = options.tum_coords(1, 1);
tum_y = options.tum_coords(1, 2);
adi_x = options.adi_coords(1, 1);
adi_y = options.adi_coords(1, 2);
tum_rad = options.tum_rad;
m_size = options.m_size;
vac_speed = options.vacuum_speed;
air_perm = options.air_permittivity;
adi_perm = options.adi_permittivity;
tum_perm = options.tum_permittivity;
skin_perm = options.skin_permittivity;
skin_thickness = options.skin_thickness;

%% Calculate permitivity
xs = linspace(-ant_phase_rad, ant_phase_rad, m_size);
ys = linspace(ant_phase_rad, -ant_phase_rad, m_size);

% Cast these to 2D for ease later
[ pix_xs, pix_ys ] = meshgrid(xs, ys);

% Compute the pixel distances from the center of each tissue
pix_dist_from_adi = sqrt((pix_xs - adi_x).^2 + (pix_ys - adi_y).^2);
pix_dist_from_tum = sqrt((pix_xs - tum_x).^2 + (pix_ys - tum_y).^2);

% Initialize breast model to be uniform background medium
breast_model = air_perm .* ones([m_size, m_size]);

% Assign the tissue components
breast_model(pix_dist_from_adi < (adi_rad + skin_thickness) ) = skin_perm;
breast_model(pix_dist_from_adi < adi_rad) = adi_perm;
breast_model(pix_dist_from_tum < tum_rad) = tum_perm;

%% Calculate the average speed of a signal
% Find the distance from each pixel to the center of the model space
pix_dist_from_center = sqrt(pix_xs.^2 + pix_ys.^2);

% Get the region of interest as all the pixels inside the circle-of-interest
roi = false([m_size, m_size]);
roi(pix_dist_from_center < ant_phase_rad) = true;

prop_speed = mean( (vac_speed ./ sqrt( breast_model(roi) ) ), "all");

end

