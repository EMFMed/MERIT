# TODO
List of goals that have yet to be met.

## Priority 1

- Add a man page document to describe core functionality for each major function.

## Priority 2

- Remove unnused legacy code and legacy tests.
- Remodel "+test/+from_list" to include tests that cover over EVERY function/script in MERIT.
- Allow for delays() to be called with either permitivity or speed.
    - Allow for delays() to be called with an array of permitivity (or speed) that corresponds to each point in the domain.
- Confirm if the functions still work as intended when signals is in the form of NxMxOxPx(...)x(...)x(...)etc. 


## Priority 3

- Add more beamformers options
- Add more metrics for measuing the error (including slightly different duplicates)
- Add more scripts to measure performance between slightly different setups.
- Try and optimize beamform and get_delays