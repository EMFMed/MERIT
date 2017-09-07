# Microwave Radar-based Imaging and Tomography: Efficient Reconstruction Software

MERIT provides free software algorithms for Delay-and-Sum reconstruction of
microwave imaging signals in medical and industrial settings.
MERIT allows users to easily and configurably test different algorithms,
easily switching between time and frequency domain signal representations.
All inbuilt algorithms can be configured to run in parallel or on GPU without
changing the code.
Features include:
 - visualize signals: view and compare signals;
 - manage signals: reorder antenna numbering, exclude channels etc., limit to
    monostatic/bistatic signals etc.;
 - estimate propagation paths based on transmit and receive locations;
 - delay signals based on propagation paths through multiple media
    with dispersive dielectric properties;
 - image using a highly configurable and extensible set of beamforming
     algorithms such as delay-and-sum;
 - analyze resulting images using a variety of metrics such as
    signal-to-clutter and signal-to-mean ratios;
 - and visualize image results in two and three dimensions.

# Examples

MERIT is designed to make the imaging code short, clear and efficient. For
example:

```matlab
%% Get user data
% signals are the responses for each channel in the time or frequency domain
% axis_ are the time or frequency points for each sample in signals
% channels describes the transmitting and receiving antenna for each channel
% antenna_locations are the antenna locations are the transmit and receive
%   locations referenced by channels
[signals, axis_, channels] = get_signals();
antenna_locations = get_antenna_locations();

%% Create imaging domain
% calculate image intensity at these points within the imaging domain
[points, axes_] = get_points();

%% Beamforming
% calculate_delays is a function to calculate the round trip propagation delay
%   from a given point or points in the imaging domain for each channel.
speed_of_propagation = beamform.speeds.from_relative_permittivity(6);
window = beamform.windows.rectangular(150);
beamformer = beamform.beamformers.DAS;
calculate_delays = beamform.delay(channels, antenna_locations, ...
  speed_of_propagation);

img = beamform.beamform(signals, points, calculate_delays, window, beamformer);

%% Resulting image manipulation
% convert from list of points to an array
img_ = beamform.un_imaging_domain(img, points, axes_{:});
```

Computationally intensive parts of the algorithm can be easily run on the GPU,
simply by passing the gpu flag to the required functions:

```matlab
img = beamform.beamform(signals, points, calculate_delays, window, beamformer,
'gpu', true);
```

# Getting started

To try MERIT:

1. Download the latest version and unzip to a chosen director.

1. Add the directory to the MATLAB path or use the builtin startup script.
`run path/to/MERIT/startup.m`

1. Get data (use samples).

1. Follow the tutorials or example scripts to view, image and analyze the data.

# Changelog

The most recent version is 0.1.0.
Notable changes to MERIT are recorded in CHANGELOG.
The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

# License

MERIT is available under the Apache 2.0 license. See LICENSE for more information.
