function tx_signal = modulate(signal,Fs, fc,freq_cutoff)
% MODULATE modulate signal
%   TX_SIGNAL = MODULATE(SIGNAL,FS,FC) returns the waveform SIGNAL 
%   modulated by a cosinusoidal carrier at frequency FC Hz, where the
%   sample rate is assumed to be FS Hz.
%
%   TX_SIGNAL = MODULATE(SIGNAL,FS,FC,FCO) low pass filters SIGNAL by an
%   ideal lowpass filter with cutoff frequency FCO before modulation

% Default carrier frequency
if nargin<3 
    fc = 35e3;
end

% Lowpass filter before mixing
if nargin<4
    signal_LPF=signal;
else
    signal_LPF=lowpass(signal,Fs,freq_cutoff);
end

Ts = 1/Fs;
t = Ts * [0:(length(signal)-1)];

% Modulate the signal    
% % % % Revise the following code  % % % % 
% xm = x;
y = cos(2*pi*fc*t); 
tx_signal = signal_LPF.*y;
end

