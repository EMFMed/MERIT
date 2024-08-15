classdef test_imaging_domain < matlab.unittest.TestCase;
  properties
  end
  methods(TestClassSetup)
    function [] = setupOnce(testCase)
    end
  end

  methods(TestClassTeardown)
    function [] = tearDownOnce(testCase)
    end
  end

  methods (TestMethodSetup)
    function [] = setup(testCase)
    end
  end

  methods(TestMethodTeardown)
    function [] = teardown(testCase)
    end
  end

  methods (Test)
    function [] = test_2d(testCase),
      domain = false(6, 6);
      domain(2:4, 2:4) = true;
      turned_on = [2, 3, 4, 2, 3, 4, 2, 3, 4; 2, 2, 2, 3, 3, 3, 4, 4, 4]';

      img = double(domain);
      img(~domain) = nan;
      subimg = img(1:max(turned_on(:, 1)), 1:max(turned_on(:, 2)));

      transform = @(a) (a-3)/1000;
      turned_on_t = transform(turned_on);
      axes_ = arrayfun(@(l) transform(1:l), size(domain), 'UniformOutput', false);

      points = merit.beamform.imaging_domain(domain);
      testCase.verifyEqual(points, turned_on);
      
      points = merit.beamform.imaging_domain(domain, axes_{:});
      testCase.verifyEqual(points, turned_on_t);
      img_ = merit.domain.img2grid(ones(size(turned_on, 1), 1), turned_on);
      testCase.verifyEqual(img_, subimg);

      img_ = merit.domain.img2grid(ones(size(turned_on, 1), 1), turned_on_t, axes_{:});
      testCase.verifyEqual(img_, img);
    end

    function [] = test_3d(testCase),
      domain = false(5, 5, 5);
      domain(3, 3, 3) = true;
      turned_on = [3,3,3];

      img = double(domain);
      img(~domain) = nan;
      subimg = img(1:max(turned_on(:, 1)), 1:max(turned_on(:, 2)), 1:max(turned_on(:, 3)));

      transform = @(a) (a-2)/1000;
      turned_on_t = transform(turned_on);
      axes_ = arrayfun(@(l) transform(1:l), size(domain), 'UniformOutput', false);

      points = merit.beamform.imaging_domain(domain);
      testCase.verifyEqual(points, turned_on);

      points = merit.beamform.imaging_domain(domain, axes_{:});
      testCase.verifyEqual(points, turned_on_t);

      img_ = merit.domain.img2grid(ones(size(turned_on, 1), 1), turned_on);
      testCase.verifyEqual(img_, subimg);

      img_ = merit.domain.img2grid(ones(size(turned_on, 1), 1), turned_on_t, axes_{:});
      testCase.verifyEqual(img_, img);
    end
  end
end
