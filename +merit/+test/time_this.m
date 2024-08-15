function execution_time = time_this(function_)
% Returns the time it took to run the function
% Does not have performance overhead
arguments
    function_ {isFunction}
end

tic;
[~] = function_();
execution_time = toc;
end

function isFunction(func)
    % Validate that the input is a function handle
    validateattributes(func, {'function_handle'}, {'scalar'}, mfilename, 'func', 1);
end