function [process_signals] = DMAS()
  % Assumes window x channels x points x ...

  function [energies] = process_(dsig),
    nChannels = size(dsig, 2);
    tmp = zeros(singlechannel(size(dsig)), 'like', dsig);
    [a, b] = triangle(nChannels);

    for c = 1:nChannels:numel(a)
      rng = c:min(numel(a),c+nChannels);
      tmp = tmp + ...
          sum(dsig(:, a(rng), :).*dsig(:, b(rng), :), 2);
    end
    energies = shiftdim(sum(tmp.^2, 1), 2);
  end

  process_signals = @process_;
end

function [a, b] = triangle(n)
  a = zeros(n*(n-1)/2, 1);
  b = zeros(n*(n-1)/2, 1);
  k = 0;
  for i = 1:n,
    for j = i+1:n,
      k = k + 1;
      a(k) = i;
      b(k) = j;
    end
  end
end

function [a] = singlechannel(a)
  a(2) = 1;
end
