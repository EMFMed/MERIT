classdef test_ummid_render < matlab.unittest.TestCase
% See if MERIT beamforming matches Reimer's data. Reuir
%{
- Test to verify that the MERIT DAS beamforming of the gen-three UM-BMID scans is
equivalent to the beamformed data taken from the following commit:

https://github.com/TysonReimer/ORR-EPM/blob/5680df25fae9a3ee0ff3fd0fbb238694efc39a11/run/reconstruct_imgs.py

- Inside the "private/" folder located in this folder function is a bash script.
- Execute the bash script and follow its instructions to prepare
"reconstruct_imgs.py" for use here.
- Run "reconstruct_imgs.py".
- Change the directory listed below in proporties to match the location of
the newly generated ".pickle" file.
%}
properties
    % The directory containing the um_bmid dataset
    um_bmid_dir = '../um_bmid/datasets/';
    % The location of the pickle file containing the beamformed data.
    pickle_path = '../orr_epm/output/gen-three/base-median-adi-rads/das_adi.pickle';
    %{
    The tolerance percentage for the maximum difference between the MERIT
    beamformed scan and the ORR-EPM beamformed scan.
    If the difference is higher than the tolerance level, this test fails.
    The max difference was recorded as 14.43%
    When the images are wrong, the max difference is typically above 90%
    %}
    tolerance_percentage = 0.15;

    % The directoy within the dataset for "gen-three clean"
    gen_three_clean_dir = '/gen-three/clean/';
    md_data = 'fd_data_s11_adi.mat';
    scan_data = 'md_list_s11_adi.mat';
end

methods(Test)
function verify_ummid_func(testCase)

% If there is no .pickle file, complain and fail.
testCase.verifyTrue(isfile(testCase.pickle_path))

% Grab the pickle data from the file
fh = py.open(testCase.pickle_path, 'rb');
py_data = py.pickle.load(fh);
fh.close();

%{
Find the number of adi scans.
This script assumes that the adi scans are in the exact same order as the
adi scans in the clean folder.
%}
number_of_scans = size(py_data, 2);

% Function to convert Reimer's data to MERIT Matlab equivalent.
% - First convert to double.
% - Then only get absolute.
% - The second axis is flipped with Reimer, so we flip it back.
extract_python_data = @(numpy_darray) flip(abs(double(numpy_darray)), 1);

% Get the first scan
first = extract_python_data(py_data{1});
% Get the size
m_size = size(first, 1);

% Get the reference data
ref_data = zeros(number_of_scans, m_size, m_size);
ref_data(1, :, :) = first;
if number_of_scans > 1
    for num = 2:number_of_scans
        ref_data(num, :, :) = extract_python_data(py_data{num});
    end
end

scan_dir = fullfile(pwd, testCase.um_bmid_dir, testCase.gen_three_clean_dir, testCase.scan_data);
md_dir = fullfile(pwd, testCase.um_bmid_dir, testCase.gen_three_clean_dir, testCase.md_data);

merit_data = verify_ummid_render(number_of_scans, m_size, pwd, scan_dir, md_dir);

nan_map = isnan(squeeze(merit_data(1, :, :)));
ref_data(:, nan_map) = nan;

diff = abs(merit_data - ref_data);
[max_diff, idx] = max(diff, [], "all");

ref_s = ref_data(idx);
merit_s = merit_data(idx);

if ref_s > merit_s
    diff_percent = max_diff / ref_s;
else
    diff_percent = max_diff / merit_s;
end

testCase.verifyLessThanOrEqual(diff_percent, testCase.tolerance_percentage)
end
end
end
