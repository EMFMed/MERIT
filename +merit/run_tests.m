function [results, suite] = run_tests(),
  suite = matlab.unittest.TestSuite.fromPackage('merit.tests', 'IncludingSubpackages', true);
  results = run(suite);
end
