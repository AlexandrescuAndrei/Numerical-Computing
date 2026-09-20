function [x, y] = parse_data(filename)
    % file input format:
    % n
    % x0 x1 ... xn
    % y0 y1 ... yn

    % TODO 1: Open the file for reading
    f = fopen(filename, 'r');
    % TODO 2: Read n, x, y from the file
    n = fscanf(f, '%d', 1);
    x = fscanf(f, '%f', n + 1);
    y = fscanf(f, '%f', n + 1);
    % TODO 3: Close the file
    fclose(f);
    x = x';
    y = y';
end