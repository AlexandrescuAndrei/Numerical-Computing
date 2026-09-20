function coef = spline_c2 (x, y)
	% Remember that the indexes in Matlab start from 1, not 0
	n = length(y) - 1;
	A = zeros(4 * n, 4 * n);
	b = zeros(4 * n, 1);
	b(1 : n + 1) = y;
	% si(x)   = ai + bi(x - xi) + ci(x - xi)^2 + di(x - xi)^3
	% si'(x)  =      bi         + 2ci(x - xi)  + 3di(x - xi)^2
	% si''(x) =                   2ci          + 6di(x - xi)

	% TOOD 1: si(xi) = yi, i = 0 : n - 1
	for i = 1 : n
		A(i, 4 * i - 3) = 1;
	end
	% TODO 2: s_n-1(xn) = yn
	A(n + 1, 4 * n - 3 : 4 * n) = [1, x(n+1) - x(n), (x(n+1) - x(n))^2, (x(n+1) - x(n))^3];
	% TODO 3: si(x_i+1) = s_i+1(x_i+1), i = 0 : n - 1
	% TODO 4: si'(x_i+1) = s_i+1'(x_i+1), i = 0 : n - 1
	% TODO 5: si''(x_i+1) = s_i+1''(x_i+1), i = 0 : n - 1
	for i = 1 : n - 1
		A(n + i + 1, 4 * i - 3 : 4 * i + 1) = [1, x(i+1) - x(i), (x(i+1) - x(i))^2, (x(i+1) - x(i))^3, -1];
		A(2 * n + i, 4 * i - 2 : 4 * i + 2) = [1, 2 * (x(i+1) - x(i)), 3 * (x(i+1) - x(i))^2, 0, -1];
		A(3 * n + i - 1, 4 * i - 1 : 4 * i + 3) = [2, 6 * (x(i+1) - x(i)), 0, 0, -2];
	end
	
	% TODO 6: s0''(x0) = 0
	A(4 * n - 1, 3) = 2;
	% TODO 7: s_n-1''(x_n) = 0
	A(4 * n, 4 * n - 1 : 4 * n) = [2, 6 * (x(n+1) - x(n))];
	% Solve the system of equations
	coef = A \ b;
end
