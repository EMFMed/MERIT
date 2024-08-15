function profile_info = profile_this(function_)
% Run and return the full profile information of a function.
% Be wary of performance overhead.
arguments
    function_ {isFunction}
end

profile("on");
[~] = function_();
profile_info = profile("info");
profile("clear");
end

function isFunction(func)
    % Validate that the input is a function handle
    validateattributes(func, {'function_handle'}, {'scalar'}, mfilename, 'func', 1);
end