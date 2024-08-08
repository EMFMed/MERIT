function [signals, new_channels] = remap(signals, new_antenna_names, original_channels)
  % Rename antennas and reorder channels according to new antenna names
  %
  % remapped_signals = remap(signals, new_antenna_names, original_channels)
  %   where:
  %     signals is the NxM array containing M channels with N points each from A antennas
  %     new_antenna_names describes the new names for the antennas and is a vector with A elements
  %       the first element is the new name for the original antenna 1 etc.
  %       the a^th element is the new name for the original antenna A.
  %       NaN can be used if the antenna at position k is not used in any channel
  %     original_channels describes the configuration of channels and is a 2xM array where the first row describes the transmitting antenna and the second row describes the receiving antenna
  %       (defaults to full ordered list (S11, S12, ..., S21, S22, ..., S(A)(A-1), S(A)(A)) if not provided)
  %
  %     remapped_signals is an ordered list of channels (S11, S12, ..., S21, S22, ..., S(A)(A-1), S(A)(A)) according to the new port names

  %% Default original channels if all S parameters provided
  if ~exist('original_channels', 'var'),
    nChannels = size(signals, 2);
    nAntennas = floor(sqrt(nChannels));
    isFullParams = nAntennas^2 == nChannels;
    if ~isFullParams,
      error('smartimaging:process:remap', 'signals must contain all the channels from S11, S12, ..., S(A)(A) if original_channels not specified.');
    end
    original_channels = [ceil((1:nChannels)/nAntennas); repmat((1:nAntennas), [1, nAntennas])]';
  end

  %% Validate input parameters
  validateattributes(signals, {'numeric'}, {'2d'}, '+process/remap.m', 'signals');
  validateattributes(new_antenna_names, {'numeric'}, {'vector'}, '+process/remap.m', 'new_port_names');
  if ~all(ismember(unique(original_channels), find(~isnan(new_antenna_names)))),
    error('smartimaging:process:remap', 'A new antenna name must be provided for all antennas in existing channels.');
  end
  validateattributes(original_channels, {'numeric'}, {'size', [size(signals, 2), 2], 'positive'}, '+process/remap.m', 'original_configuration');

  %% Reorder antennas
  new_channels = new_antenna_names(original_channels);
  new_channels = reorder_tx_rx(new_channels); % ensure transmitting antenna always smaller than or equal to receiving antenna
  [~, new_channels_index] = sortrows(new_channels);
  signals = signals(:, new_channels_index);
end

function [channels] = reorder_tx_rx(channels),
  % reorder tx and rx pair if alternate pair doesn't exist.
  % e.g. if channels are [1, 1; 1, 2; 2, 2] and swapping 2 and 1,
  % the correct new channel order is [3, 2, 1] not [3, 1, 2]

  less_than = find(channels(:, 1) > channels(:, 2));
  reverse_exists = ismember(channels(less_than, end:-1:1), channels, 'rows')';
  channels(less_than(~reverse_exists), :) = sort(channels(less_than(~reverse_exists), :), 2);
end
