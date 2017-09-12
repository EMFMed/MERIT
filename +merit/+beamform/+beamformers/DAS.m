function [process_signals] = DAS()
  % Assumes window x channel x points x ...

  function [energies] = process_(delayed_signals),
    energies = shiftdim(sum(sum(delayed_signals, 2).^2, 1), 2);
  end
  process_signals = @process_;
end
