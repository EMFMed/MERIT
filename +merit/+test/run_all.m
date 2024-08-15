function [results, suite] = run_all()
% Run all tests from the list
  suite = matlab.unittest.TestSuite.fromPackage('merit.test.from_list', 'IncludingSubpackages', true);
  results = run(suite);
end