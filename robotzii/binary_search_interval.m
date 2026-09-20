function index = binary_search_interval(x, xi)
    % Binary search to find the interval [x(j), x(j+1)] containing xi
    low = 1;
    high = length(x) - 1;
    if xi == x(length(x));
        index = length(x) - 1;
        return;
    end
    while low <= high
        mid = floor((low + high) / 2);
        if xi >= x(mid) && xi < x(mid + 1)
            index = mid;
            return;
        elseif xi < x(mid)
            high = mid - 1;
        else
            low = mid + 1;
        end
    end
end
