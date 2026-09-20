function x = oscillator(freq, fs, dur, A, D, S, R)
  x = 0;
  t = 0 : 1/fs : dur-1/fs;
  f = sin(2 * pi * freq * t);
  nr_attack = floor(A * fs);
  nr_decay = floor(D * fs);
  nr_release = floor(R * fs);
  total = ceil(dur * fs);
  nr_sustain = total - nr_attack - nr_decay - nr_release;
  attack_env = linspace(0, 1, nr_attack);
  decay_env = linspace(1, S, nr_decay);
  sustain_env = ones(1, nr_sustain) * S;
  release_env = linspace(S, 0, nr_release);
  envelope = [attack_env decay_env sustain_env release_env];
  x = f .* envelope;
  x = x';
end

