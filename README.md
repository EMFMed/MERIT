# Microwave Radar-based Imaging Toolbox: Efficient Reconstruction Software

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
%% Load sample data (antenna locations, frequencies and signals)
frequencies = dlmread('data/frequencies.csv');
antenna_locations = dlmread('data/antenna_locations.csv');
channel_names = dlmread('data/channel_names.csv');

scan1 = dlmread('data/B0_P3_p000.csv');
scan2 = dlmread('data/B0_P3_p036.csv');

%% Perform rotation subtraction
signals = scan1-scan2;

%% Generate imaging domain
[points, axes_] = merit.domain.hemisphere('radius', 7e-2, 'resolution', 2.5e-3);

%% Calculate delays for synthetic focusing
delays = merit.beamform.get_delays(channel_names, antenna_locations, ...
  'relative_permittivity', 8);

%% Perform imaging
img = abs(merit.beamform(signals, frequencies, points, delays, ...
        merit.beamformers.DAS));

%% Plot image using MATLAB functions
im_slice = merit.visualize.get_slice(img, points, axes_, 'z', 35e-3);
imagesc(axes_{1:2}, im_slice);
```

In a few lines of code, radar-based images can be efficiently created.
MERIT allows the user to change the beamformer, imaging domain and other features easily and simply.
Functions are designed to accept options allowing the user to easily change the imaging procedure.

# Getting started

To try MERIT:

Follow the [Getting Started Guide](https://github.com/EMFMed/MERIT/wiki/Getting-Started) and look at [existing publications](https://github.com/EMFMed/MERIT/wiki#publications-using-merit) that use MERIT.

# Changelog

The most recent version is 0.1.0.
Notable changes to MERIT are recorded in CHANGELOG.
The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

# License

MERIT is available under the Apache 2.0 license. See LICENSE for more information.
