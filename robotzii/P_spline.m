function y_interp = P_spline(coef, x, x_interp)
    % P_spline - Evaluates a piecewise polynomial spline at given points.
    % Inputs:
    %   coef - Matrix of coefficients for the spline.
    %   x - Vector of x points where the spline knots are located.
    %   x_interp - Vector of x values where the spline should be evaluated.
    % Output:
    %   y_interp - Vector of interpolated y values corresponding to x_interp.
    n_intervals = length(x) - 1;
    n_interp_points = length(x_interp);
    y_interp = zeros(n_interp_points, 1);
    for i = 1 : n_interp_points
        xi = x_interp(i);
        j = binary_search_interval(x, xi);
        a = coef(4 * j - 3);
        b = coef(4 * j - 2);
        c = coef(4 * j - 1);
        d = coef(4 * j);
        dx = xi - x(j);
        y_interp(i) = a + b*dx + c*dx^2 + d*dx^3;
    end
end
