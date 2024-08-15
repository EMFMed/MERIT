function [scan, rotated_scan] = load(ph, pl)
   filename = sprintf('%s_P%d_p000.csv', ph, pl);
   rot_filename = sprintf('%s_P%d_p036.csv', ph, pl);
   
   % path to scans
   folder_path = '+example_data/';

   % construct filename and search for the file in folder_path
   filepath = fullfile(folder_path, filename);
   rot_filepath = fullfile(folder_path, rot_filename);


   % Check if the files exist
    if ~isfile(filepath)
        error('Error: %s does not exist.', filepath);
    end
    
    if ~isfile(rot_filepath)
        error('Error: %s does not exist.', rot_filepath);
    end

    scan = dlmread(filename);
    rotated_scan = dlmread(rot_filename);
end