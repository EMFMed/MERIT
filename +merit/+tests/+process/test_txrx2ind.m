classdef test_txrx2ind < matlab.unittest.TestCase;
  properties
    channels
    dim_size
  end
  properties(ClassSetupParameter)
    nAntennas = {10, 40, 60};
  end
  methods(TestClassSetup)
    function [] = setup(tc, nAntennas)
      tc.channels = [floor((0:nAntennas.^2-1)/nAntennas)+1; repmat(1:nAntennas, [1, nAntennas])]';

      state = rng;
      rng(10);
      tc.addTeardown(@rng, state);

      tc.dim_size = 10;
    end
  end

  methods (Test)
    function [] = test_col(tc)
      tx = randi(max(tc.channels(:)), [tc.dim_size, 1]);
      rx = randi(max(tc.channels(:)), [tc.dim_size, 1]);

      i = merit.process.txrx2ind(tc.channels, tx, rx);

      tc.verifyEqual(size(i), [tc.dim_size, 1]);
      tc.verifyEqual([tx(:), rx(:)], tc.channels(i(:), :));
    end
    function [] = test_row(tc)
      tx = randi(max(tc.channels(:)), [1, tc.dim_size]);
      rx = randi(max(tc.channels(:)), [1, tc.dim_size]);

      i = merit.process.txrx2ind(tc.channels, tx, rx);

      tc.verifyEqual(size(i), [1, tc.dim_size]);
      tc.verifyEqual([tx(:), rx(:)], tc.channels(i(:), :));
    end
    function [] = test_twod(tc),
      tx = randi(max(tc.channels(:)), tc.dim_size);
      rx = randi(max(tc.channels(:)), tc.dim_size);

      i = merit.process.txrx2ind(tc.channels, tx, rx);

      tc.verifyEqual(size(i), [tc.dim_size, tc.dim_size]);
      tc.verifyEqual([tx(:), rx(:)], tc.channels(i(:), :));
    end
    function [] = test_threed(tc),
      tx = randi(max(tc.channels(:)), [1, 1, 1]*tc.dim_size);
      rx = randi(max(tc.channels(:)), [1, 1, 1]*tc.dim_size);

      i = merit.process.txrx2ind(tc.channels, tx, rx);

      tc.verifyEqual(size(i), [1, 1, 1]*tc.dim_size);
      tc.verifyEqual([tx(:), rx(:)], tc.channels(i(:), :));
    end
  end
end
