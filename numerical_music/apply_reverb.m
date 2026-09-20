function signal = apply_reverb(signal, impulse_response)
  mono = stereo_to_mono(impulse_response);
  signal = fftconv(signal, mono);
  signal = signal / max(abs(signal));
end

