function reduced_mat = preprocess(mat, min_reviews)
  # TODO: Remove all user rows from `mat` that have strictly less then `min_reviews` reviews.
  [m n] = size(mat);
  reduced_mat = zeros(1, n);
  p = 0;
  for i = 1 : m
    s = 0;
    for j = 1 : n
      if mat(i, j)~=0
        s = s + 1;
      end
    end
    if s >= min_reviews
      p = p + 1;
      reduced_mat(p, :) = mat(i, :);
    end
  end
end
