function signal = low_pass(signal, fs, cutoff_freq)
  fourier = fft(signal);
  signal_len = length(signal);
  f = (0 : signal_len-1) * fs / signal_len;
  v = zeros(1, signal_len);
  for i = 1 : signal_len
    if f(i) < cutoff_freq
      v(i) = 1;
    end
  end
  get_lower = fourier .* v';
  signal = ifft(get_lower);
  signal = signal / max(abs(signal));
end

