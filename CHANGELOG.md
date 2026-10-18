# Changelog
Notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2024-08-20

### Added

- Added back expand2.m (needed to complete tests)

### Changed

- Cleaner getting_started.m
- Renamed "beamformers" to "beamformer"
- Moved imaging_domain from "+beamform" to "+process"
- Renamed imaging_domain.m to get_points.m
- Renamed get_delays.m to get_delay.m
- Moved "get_delay.m" from "+beamform" to one level above ("+merit")
- Moved "+windows" from "+beamform" to "+process"
- Moved all files from "+utility/" to "+process/"
- Updated TODO list
- Updated example code in README.md

### Removed

- Deleted "+beamform/"
- Deleted "+utilities/"

## [1.0.0] - 2024-08-15

### Added

- TODO list
- Example dataset from BRIGID (w/ example scripts to load and use).
- Ability to load and use Tyson Reimer's data from UM-BMID w/ example script.
- Functions to measure performance (w/ example script)
- Function to display the 3D scan

### Changed

- Renamed multiple functions and namespaces
- Moved some functions to different namespaces

### Removed

- Unused functions (expand2.m)

