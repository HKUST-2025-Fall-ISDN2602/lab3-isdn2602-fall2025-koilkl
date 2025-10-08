function [rx_signal, m]= demodulate_signal(x,Fs,fc,freq_cutoff,bpf_bw)
%DEMODULATE  Demodulate a signal

if nargin<4 
 freq_cutoff=10e3;
end
if nargin<5 
    x_BPF = x;
else %bandpass filter
   low_freq = fc-bpf_bw;  % determine the low freq cutoff of the BPF, general expression
   high_freq = fc+bpf_bw; % determine the high freq cutoff of the BPF, general expression
   x_BPF = bandpass(x, high_freq, low_freq, Fs);
end

% set up vector of time indices
N = length(x_BPF);
Ts = 1/Fs;
t = Ts * [0:(N-1)];

% t index of y(t) same as of x(t), y the carrier
y = cos(2*pi*fc*t);
m = x_BPF.*y;
rx_signal=lowpass(m,Fs,freq_cutoff);