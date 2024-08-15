classdef test_remap < matlab.unittest.TestCase;
  properties
    nAntennas = 3;
    nPoints = 201;
    renaming_scheme;
    expected_order_full;
    expected_order_partial;
    original_order_partial;
  end
  methods(TestClassSetup)
    function [] = setupOnce(tc)
      fullSParams = @(n) [ceil((1:n)'/n), repmat((1:n)', [n, 1])];
      function [partial] = partialSParams(n)
        partial = [];
        for tx = 1:n,
          for rx = tx:n,
            partial(end+1, :) = [tx, rx];
          end
        end
      end

      tc.renaming_scheme = [1:tc.nAntennas;
          2, 1, 3:tc.nAntennas;
          tc.nAntennas:-1:1;
          tc.nAntennas:-1:3, 1, 2];
      tc.expected_order_full = [1:tc.nAntennas^2;
          5, 4, 6, 2, 1, 3, 8, 7, 9;
          tc.nAntennas^2:-1:1;
          5, 6, 4, 8, 9, 7, 2, 3, 1];

      triangle_sum = @(x) x*(x+1)/2;
      tc.expected_order_partial = [1:triangle_sum(tc.nAntennas);
        4, 2, 5, 1, 3, 6;
        6, 5, 3, 4, 2, 1;
        4, 5, 2, 6, 3, 1];
      tc.original_order_partial = partialSParams(tc.nAntennas);
    end
  end

  methods (Test)
    function [] = test_full(tc),
      return
      tc.assumeEqual(size(tc.renaming_scheme, 1), size(tc.expected_order_full, 1));
      sigs = rand(tc.nPoints, tc.nAntennas^2);
      for i = 1:size(tc.expected_order_full, 1),
        tc.verifyEqual(merit.process.remap(sigs, tc.renaming_scheme(i, :)), sigs(:, tc.expected_order_full(i, :)));
      end
    end

    function [] = test_partial(tc),
      tc.assumeEqual(size(tc.renaming_scheme, 1), size(tc.expected_order_partial, 1));
      sigs = rand(tc.nPoints, size(tc.expected_order_partial, 2));
      for i = 1:size(tc.expected_order_partial, 1),
        remapped = merit.process.remap(sigs, tc.renaming_scheme(i, :), tc.original_order_partial);
        tc.verifyEqual(remapped, sigs(:, tc.expected_order_partial(i, :)));
      end
    end
  end
end
