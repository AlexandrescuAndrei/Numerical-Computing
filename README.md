# Numerical-Computing

A collection of numerical computing exercises implemented in **MATLAB/Octave**, covering digital signal processing, audio synthesis, interpolation methods, and recommendation systems based on matrix factorization.

The repository is divided into three main parts. The first works with digital audio signals and includes stereo-to-mono conversion, spectrogram computation, Fourier-based filtering, reverb, oscillators, ADSR envelopes, and procedural sound generation. The second explores polynomial interpolation using Vandermonde matrices and natural cubic splines for reconstructing and visualizing trajectories. The third implements a recommendation system using matrix preprocessing, truncated Singular Value Decomposition, and cosine similarity.

The project combines numerical methods with practical applications in audio processing, interpolation, and data analysis. Several algorithms are implemented explicitly in MATLAB/Octave in order to understand the mathematical operations behind the final results instead of treating them entirely as black-box library calls.

## Numerical Music and Signal Processing

The first part of the project focuses on manipulating and generating digital audio signals.

Audio samples are represented as numerical vectors and matrices, allowing signal-processing operations to be expressed through standard numerical operations such as averaging, multiplication, Fourier transforms, convolution, and normalization.

The `stereo_to_mono` function converts a stereo signal into a mono signal by averaging the channels for every audio sample.

After the conversion, the resulting signal is normalized according to its maximum absolute amplitude.

This ensures that the waveform remains inside an appropriate numerical range and prevents unnecessary differences in amplitude caused by the channel-combination process.

The resulting mono representation is then used by several other parts of the audio-processing pipeline.

## Spectrogram Computation

The project contains a custom spectrogram implementation for analyzing how the frequency content of a signal changes over time.

The audio signal is divided into fixed-size windows.

Each window is multiplied by a Hanning window before applying the Fourier transform. Windowing reduces discontinuities at the boundaries of each analyzed segment and provides a more useful frequency-domain representation.

A Fourier transform with a size equal to twice the selected window size is then calculated.

Because the spectrum of a real-valued signal contains mirrored information, the implementation keeps the first half of the transformed values.

The magnitude of the resulting frequency components is stored as one column of the spectrogram matrix.

The process is repeated for every complete window in the signal.

Along with the spectrogram matrix, the implementation calculates the corresponding frequency and time vectors.

The frequency vector maps rows of the matrix to frequencies in Hertz, while the time vector associates each column with its position inside the original signal.

A separate plotting function displays the logarithm of the spectrogram magnitudes using time and frequency as the plot axes.

This provides a visual representation of the signal in both the time and frequency domains.

## Oscillators and ADSR Envelopes

The repository also contains a simple sound synthesizer based on sinusoidal oscillators.

The `oscillator` function generates a sinusoidal waveform using a requested frequency, sampling rate, and duration.

Instead of maintaining a constant amplitude throughout the entire note, the generated waveform is multiplied by an **ADSR envelope**.

The envelope is divided into four stages:

- Attack
- Decay
- Sustain
- Release

The attack stage gradually increases the amplitude from zero to its maximum.

The decay stage transitions from the maximum amplitude to the selected sustain level.

The sustain stage keeps the signal at a constant amplitude for the remaining middle portion of the note.

The release stage gradually reduces the amplitude from the sustain level back to zero.

The number of samples associated with every stage is calculated from its duration and the sampling frequency.

Linear interpolation through `linspace` is used to construct the attack, decay, and release sections, while the sustain section is represented by a constant vector.

All four components are concatenated and multiplied element by element with the generated sine wave.

This creates a basic synthesized instrument sound with a more realistic amplitude evolution than a raw sine wave.

## Instrument and Pattern Generation

The audio section can construct complete signals from instrument descriptions stored in CSV files.

`create_instruments` reads several instrument definitions and generates the waveform associated with each one using the oscillator implementation.

The generated signals are stored in a `containers.Map`, using the instrument name as the key.

A music pattern is represented as a sequence of instrument names separated into small beat subdivisions.

The underscore character represents an empty position where no new instrument should begin.

`parse_pattern` converts this representation into an audio waveform.

The number of samples corresponding to one beat is calculated from the sampling frequency and the selected BPM value.

Each beat is divided into four smaller units, and instruments are inserted into the output signal at their corresponding positions.

The `create_sound` function loads two patterns from a file, generates both signals, extends the shorter one if necessary, adds the two layers together, and normalizes the resulting waveform.

This creates a small numerical music-generation pipeline based entirely on generated waveforms and timing calculations.

## Fourier-Based Low-Pass Filtering

A low-pass filter is implemented using the Fourier transform.

The input signal is first transformed from the time domain into the frequency domain using `fft`.

A frequency vector is constructed according to the sampling rate and the length of the signal.

The implementation then builds a mask whose entries are equal to one for frequencies below the selected cutoff frequency and zero for the remaining frequencies.

This mask is multiplied element by element with the Fourier-transformed signal.

The filtered representation is then converted back to the time domain using the inverse Fourier transform.

Finally, the signal is normalized.

This provides a direct numerical demonstration of frequency-domain filtering: components outside the allowed frequency region are removed before reconstructing the signal.

## Reverb through Convolution

The project also implements a reverb effect using an impulse response.

The impulse response is first converted to mono to obtain a single-channel representation.

The audio signal is then convolved with this impulse response using FFT-based convolution.

Convolution with an impulse response approximates the effect that an acoustic environment has on an input sound.

After the convolution is performed, the resulting waveform is normalized.

The included studio script applies reverb and low-pass filtering both separately and in different orders, allowing the effects of the transformations to be compared using both generated audio and spectrograms.

The repository also includes example WAV files used by the signal-processing pipeline.

## Interpolation and Robot Trajectories

The second part of the project focuses on numerical interpolation.

A sequence of known points is read from a file and used to construct continuous curves that approximate a trajectory passing through those points.

Two interpolation approaches are implemented:

- Vandermonde polynomial interpolation
- Natural cubic spline interpolation

Both methods generate coefficients from the original data and then evaluate the resulting interpolation functions at additional points.

Plotting utilities are included for visually comparing the original points with the reconstructed trajectory.

## Vandermonde Interpolation

The Vandermonde interpolation method represents the entire trajectory using a single polynomial.

For a collection of known coordinates, the implementation constructs a Vandermonde matrix.

Each column contains the input values raised to a specific power.

The first column contains values raised to the power zero, the second column contains the first powers, and the pattern continues until all required polynomial coefficients are represented.

The coefficient vector is obtained by solving the resulting linear system using MATLAB/Octave's matrix division operator.

Once these coefficients are available, `P_vandermonde` evaluates the interpolation polynomial at any requested set of positions.

For every interpolation point, the implementation calculates the weighted sum of the corresponding powers of the input value.

The repository also contains a plotting function that generates many points across the domain and displays the resulting polynomial together with the original data points.

This provides a direct application of linear systems to polynomial interpolation.

## Natural Cubic Spline Interpolation

The project also implements **C2 cubic spline interpolation**.

Instead of using one high-degree polynomial for the entire dataset, the spline method associates a separate cubic polynomial with every interval between consecutive input points.

Each interval has four coefficients describing its local cubic polynomial.

These coefficients must satisfy several constraints.

Each spline segment must pass through the required data points.

Neighboring segments must produce the same function value at their shared boundary.

Their first derivatives must also match, ensuring that the curve does not suddenly change direction.

Their second derivatives must match as well, providing additional smoothness.

The implementation additionally applies natural spline boundary conditions by setting the second derivative to zero at the beginning and end of the complete trajectory.

All of these equations are placed into one linear system represented by a matrix `A` and a vector `b`.

Solving this system produces the coefficients of all spline segments.

The resulting curve is therefore continuous together with its first and second derivatives.

## Spline Evaluation and Interval Search

Evaluating a spline requires determining which cubic polynomial corresponds to a particular interpolation point.

The repository implements a binary-search function for this purpose.

Given the ordered vector of known x-coordinates and a requested interpolation value, `binary_search_interval` locates the interval containing that value.

Once the correct interval has been identified, `P_spline` retrieves the four coefficients belonging to that segment.

The input value is expressed relative to the beginning of the interval, and the cubic polynomial is evaluated using the local coordinate.

This process is repeated for every requested interpolation point.

Using binary search prevents the implementation from scanning every interval sequentially whenever a new value has to be evaluated.

The spline plotting utility creates a dense set of points between the minimum and maximum input coordinates and evaluates the spline at all of them, producing a smooth graphical representation of the reconstructed trajectory.

## Recommendation System

The third part of the repository implements a numerical recommendation system.

The input is a matrix in which rows correspond to users and columns correspond to themes or items.

Non-zero matrix values represent existing user reviews.

Before generating recommendations, the matrix is preprocessed in order to remove users who do not have enough available review information.

For every row, the implementation counts the non-zero values.

Only users with at least the requested number of reviews are kept in the reduced matrix.

This produces a denser and more useful dataset for the following matrix-factorization step.

## Singular Value Decomposition

The reduced review matrix is processed using truncated **Singular Value Decomposition** through `svds`.

The decomposition produces the matrices `U`, `S`, and `V`, using only a selected number of latent features.

The recommendation algorithm uses the representation contained in `V` to compare themes in this reduced latent space.

Instead of directly comparing the original review columns, themes are therefore represented through features obtained from the matrix factorization.

This is a common idea in recommendation systems because latent representations can capture relationships that are not immediately visible from individual raw ratings.

The number of retained features is configurable through the `num_features` parameter.

## Cosine Similarity and Recommendations

Similarity between two latent theme vectors is calculated using **cosine similarity**.

The implementation computes the dot product of the vectors and divides it by the product of their Euclidean norms.

The resulting value measures how closely the two vectors point in the same direction.

To generate recommendations, the selected theme is compared with every other theme.

The liked theme itself is excluded from consideration.

All similarity values are stored together with the corresponding theme indexes.

The implementation then sorts these values in descending order while applying the same swaps to the index vector.

The first requested indexes become the final recommendations.

This combines data preprocessing, dimensionality reduction, vector similarity, and ranking into a complete recommendation pipeline.

## Project Structure

The repository is organized into three main implementation directories:

- `numerical_music/` — digital signal processing, audio synthesis, spectrograms, filtering, reverb, instrument generation, and example audio data
- `robotzii/` — Vandermonde interpolation, cubic spline interpolation, interval search, data parsing, and trajectory plotting
- `recommendations/` — matrix loading, preprocessing, Singular Value Decomposition, cosine similarity, and recommendation generation

The `numerical_music` directory includes functions such as `stereo_to_mono`, `spectrogram`, `oscillator`, `low_pass`, `apply_reverb`, `create_instruments`, `parse_pattern`, and `create_sound`.

The `robotzii` directory contains the numerical interpolation functions, including `vandermonde`, `P_vandermonde`, `spline_c2`, `P_spline`, and `binary_search_interval`.

The `recommendations` directory contains the complete recommendation pipeline through `read_mat`, `preprocess`, `cosine_similarity`, and `recommendations`.

The repository also includes the assignment checker infrastructure and a Dockerfile containing an Octave and Python environment used by the provided testing setup.

## Running the Code

The implementations use MATLAB/Octave-style `.m` files and are intended to run with **GNU Octave**.

The individual functions can be executed independently depending on the numerical task being studied.

For the audio-processing section, `studio.m` acts as an example pipeline.

It reads audio files, converts stereo signals to mono, computes spectrograms, generates a synthetic signal from a music description, applies low-pass filtering and reverb, writes processed signals to WAV files, and visualizes their frequency content.

The interpolation functions can be used by loading a set of coordinates and generating either Vandermonde or cubic-spline coefficients before evaluating the resulting curve.

The recommendation component accepts a CSV review matrix together with the selected theme, requested number of recommendations, minimum number of reviews, and number of latent features.

The repository also contains checker scripts and a Docker-based environment supplied for testing the assignment implementations.

## Technologies and Concepts

- MATLAB / GNU Octave
- Numerical computing
- Digital signal processing
- Audio synthesis
- Digital audio
- Sampling frequency
- Stereo-to-mono conversion
- Signal normalization
- Fourier Transform
- FFT
- Inverse FFT
- Spectrograms
- Hanning windows
- Frequency-domain analysis
- Low-pass filtering
- Convolution
- Impulse responses
- Reverb
- Sinusoidal oscillators
- ADSR envelopes
- Procedural sound generation
- WAV audio processing
- Polynomial interpolation
- Vandermonde matrices
- Linear systems
- Natural cubic splines
- C2 continuity
- First and second derivatives
- Binary search
- Piecewise polynomial evaluation
- Numerical visualization
- Recommendation systems
- Matrix preprocessing
- Singular Value Decomposition
- Truncated SVD
- Latent features
- Cosine similarity
- Vector norms
- Similarity ranking
- CSV data processing
- Docker
