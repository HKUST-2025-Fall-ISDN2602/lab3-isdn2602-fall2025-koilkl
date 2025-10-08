function output_wave=lowpass(input_wave,Fs,cutoff_freq)
% LOWPASS lowpass filter a waveform
%   OUTPUT_WAVE = LOWPASS(INPUT_WAVE,FS,CUTOFF_FREQ) low pass filters the
%   signal INPUT_WAVE with an ideal lowpass filter with cutoff frequency
%   equal to CUTOFF_FREQ, where the sampling frequency is FS.  The units of
%   CUTOFF_FREQ and FS must be the same.

narginchk(3,3);

fco = cutoff_freq/Fs;

% compute fft of input_wave
input_fft = fft(input_wave);

% find vector of normalized frequencies
freq = fftfreq(length(input_wave));

% zero out components with frequencies larger than cutoff
ind = find(abs(freq) > fco);
input_fft(ind) = 0;

% inverse Fourier Transform
output_wave = real(ifft(input_fft));

end

% OLD CODE
% cof_id = cutoff_freq*length(input_wave)/Fs;
% f= fftshift(fft(input_wave));
% c = round(0.5*length(f));
% f(1:c-cof_id)= 0;
% f(c+cof_id:end)= 0;
% output_wave = real(ifft(fftshift(f)));
