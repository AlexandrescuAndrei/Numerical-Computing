function [S f t] = spectrogram(signal, fs, window_size)
	S = 0;
  f = 0;
  t = 0;
  len = length(signal);
  cnt_windows = floor(len / window_size);
  S = zeros(window_size, cnt_windows);
  for i = 1 : cnt_windows
    % a = 1 + (i - 1) * window_size;
    % b = i * window_size;
    window = signal(1 + (i - 1) * window_size : i * window_size);   
    window = window .* hanning(window_size);
    transfft = fft(window, 2 * window_size);
    transfft = transfft(1 : window_size);
    S(:, i) = abs(transfft);
  end
  f = zeros(window_size, 1);
  for i = 1 : window_size
    f(i) = (i - 1) * fs / (2 * window_size);
  end
  t = zeros(cnt_windows, 1);
  for i = 1 : cnt_windows
    t(i) = (i - 1) * window_size / fs;
  end
endfunction

