function [process_signals] = DAS()
%{
Create DAS beamform function.
We must use a DAS different from MERIT.
This version does not perform element-wise squaring after the first
summation.
%}
  % Assumes window x channel x points x ...
  function [energies] = process_(delayed_signals)
    energies = shiftdim(sum(sum(delayed_signals, 2), 1), 2);
  end
  process_signals = @process_;
end
