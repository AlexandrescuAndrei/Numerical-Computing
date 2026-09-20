function recoms = recommendations(path, liked_theme, num_recoms, min_reviews, num_features)
  # TODO: Get the best `num_recoms` recommandations similar with 'liked_theme'.
  mat = read_mat(path);
  red_mat = preprocess(mat, min_reviews);
  [U S V] = svds(red_mat, num_features);
  V = V';
  [m n] = size(V);
  v = -ones(1, n);
  for i = 1 : liked_theme - 1
    v(i) = cosine_similarity(V(:, i), V(:, liked_theme));
  end
  for i = liked_theme + 1 : n
    v(i) = cosine_similarity(V(:, i), V(:, liked_theme));
  end
  e = 1 : length(v);
  for i = 1 : length(v) - 1
    for j = i + 1 : length(v)
      if v(i) < v(j)
        aux = v(i);
        v(i) = v(j);
        v(j) = aux;
        aux = e(i);
        e(i) = e(j);
        e(j) = aux;
      end
    end
  end
  recoms = e(1 : num_recoms);
end








