#!/usr/bin/env bash
# This is a script designed to get the beamformed image data from Tyson Reimer, using his code and his functions.
# This is so that we may compare his beamformed data to our beamformed data.
# Make sure to change the 
echo " 
Matlab currently does not support the latest Python version. Make sure to set Matlab to use Python 3.11
The ORR-EPM repo works with the current Python, but not the current Numpy package. Make sure to use Numpy 1.26.4

This script was tested with this commit:
https://github.com/TysonReimer/ORR-EPM/tree/5680df25fae9a3ee0ff3fd0fbb238694efc39a11

The script is designed to accept the following file as an argument:
'ORR-EPM/run/reconstruct_imgs.py'

For running the ORR-EPM repo, you need the scan data. The link to the scan data is in a google drive located in the ReadMe of this repo:
https://github.com/UManitoba-BMS/UM-BMID/tree/62c97b8c75f96b275a11f4cb920f03d185f7e0c5
"
set -eo pipefail # Exit if any command fails. Print command.

# Check if an argument was provided
if [ $# -ne 1 ]; then
    echo -e "WARNING! No argument provided! Please read the source code.\nPlease provide the location of 'reconstruct_imgs.py' next time you run this command."
    exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
    echo "Error: File '$1' not found."
    exit 1
fi

# Create a copy of the original file
original_file="$1"
directory=$(dirname "$1")

copied_file="$directory/RUN_ME.py"

# This is where the "simple clean" .pickle scans should be from the UM-BMID google drive. These scans are not reference subtracted. The python program does that for us.
gen_three_simple_clean_python_data='../um_bmid/datasets/gen-three/simple-clean/python-data/'

cp "$original_file" "$copied_file"

## Use sed to optimize the performance of Reimer's script.
# Shrink the pixel count:
sed -i 's#\b__M_SIZE = 150\b#__M_SIZE = 50#g' "$copied_file"
# We only care about das beamforming:
sed -i 's#\bdo_dmas = True\b#do_dmas = False#g' "$copied_file"
sed -i 's#\bdo_orr = True\b#do_orr = False#g' "$copied_file"
# Change the input and output paths:
sed -i "s#__D_DIR = os.path.join(get_proj_path(), 'data/umbmid/g3/')#__D_DIR = os.path.join(get_proj_path(), ${gen_three_simple_clean_python_data})#g" "$copied_file"
#sed -i "s#__O_DIR = os.path.join(get_proj_path(), \"output/orr/g3/\")#__O_DIR = os.path.join(get_proj_path(), \"output/gen-three/\")#g" "$copied_file"
sed -i "s#s11 = load_pickle(os.path.join(__D_DIR, 'g3_s11.pickle'))#s11 = load_pickle(os.path.join(__D_DIR, 'fd_data_gen_three_s11.pickle'))#g" "$copied_file"
sed -i "s#md = load_pickle(os.path.join(__D_DIR, 'g3_md.pickle'))#md = load_pickle(os.path.join(__D_DIR, 'metadata_gen_three.pickle'))#g" "$copied_file"

# We don't have access to this data, so we remove the check for it (we don't need it anyway).
sed -i -n -e '/    # Load glycerin DAK dielectric data/!{p;d;};n;' -e ':a' -e 'n;/./ba' "$copied_file"
sed -i -n -e '/    # Interpolate to the scan frequencies/!{p;d;};n;' -e ':a' -e 'n;/./ba' "$copied_file"
# This is unnecessary for our use case:
sed -i -n -e '/            # Delete the previously-saved DMAS files to save disk space/!{p;d;};n;' -e ':a' -e 'n;/./ba' "$copied_file"
sed -i -n -e '/            # Delete the previously-saved ORR files to save disk space/!{p;d;};n;' -e ':a' -e 'n;/./ba' "$copied_file"
sed -i -n -e '/            # Delete the previously-saved .pickle to save disk space/!{p;d;};n;' -e ':a' -e 'n;/./ba' "$copied_file"
sed -i -n -e '/                # Remove the old file/!{p;d;};n;' -e ':a' -e 'n;/./ba' "$copied_file"
sed -i -n -e '/                os.remove(os.path.join(adi_o_dir,/!{p;d;};n;' -e ':a' -e 'n;/./ba' "$copied_file"

echo "File '$original_file' copied and modified."
echo "Modified copy saved as '$copied_file'."
echo "Now just run this file and grab use the newly generated 'das_adi.pickle' for the Matlab test. This file should be located inside 'orr/g3/base-median-adi-rads/'"
