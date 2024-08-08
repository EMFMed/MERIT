function [process_signals] = DAS()
  % Assumes window x channel x points x ...

  function [energies] = process_(delayed_signals),
    % shift the dimensions of the matrix (sum of the 1st column of the
    % square of the sum of the second column of delayed_signals)
    energies = shiftdim(sum(sum(delayed_signals, 2).^2, 1), 2);
  end
  process_signals = @process_;
end


% sum of 2nd column of delayed signals squared
% sum of 1st column of that matrix
% shift that 2 to the left (wrapping)