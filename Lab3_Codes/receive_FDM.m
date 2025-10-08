function [rx_speech]=receive_FDM(rx_wave, freq)
% rx_speech: speech in baseband % rx_wave: modulated and multiplexed signals 
% freq: carrier fequency, dep. on which speech to extract

% test with rx_wave, load('speech_set1.mat'); 
freq = 10e3;

Fs=1e5; % sampling frequency
N=length(rx_wave); % # of samples
 
afft_rx_wave = abs(fftshift(fft(rx_wave))); % amplitude spectrum of signal
k=-N/2:N/2-1; % total N pts

figure;
subplot(5,1,1); 
plot(k,afft_rx_wave);
title('Amplitude spectrum of received signal rx-wave, in k');
xlabel('k'); ylabel('Magnitude');


%---your task1: spectrum of rx_wave ----write the missing codes----------%
% Plot amplitude spectrum of the received (modulated) signal, rx_wave in Hz

f=k*(Fs/N);
% corresponding freq in Hz, express f in terms of k,N & Fs.
subplot(5,1,2); plot(f, afft_rx_wave); % plot spectrum in Hz
title('Amplitude spectrum of received signal rx-wave, in Hz');
xlabel('Frequency (Hz)'); ylabel('Magnitude');
 


%------your task2: Apply BPF--write the missing codes--------%
% Design a suitable bandpass filter for rx_wave with suitable cutoff freq.

w1=4e3;  % baseband bandwidth of the speech
low_freq= freq-w1;  % determine the low freq cutoff of the BPF, general expression 
high_freq= freq+w1; % determine the high freq cutoff of the BPF, general expression

rx_wave_BPF=bandpass(rx_wave, high_freq, low_freq); 
%function bandpass is provided, it is BPF. 
%rx_wave_BPF: signal after BPF, it is in time domain.
 
abps_rx_wave = abs(fftshift(fft(rx_wave_BPF))); 
% amplitude spectrum of signal after BPF, abps_rx_wave

subplot(5,1,3); plot(f, abps_rx_wave);   % plot spectrum of abps_rx_wave in Hz
title('Amplitude spectrum of rx-wave after BFP');
xlabel('Frequency (Hz)');ylabel('Magnitude');

 
%--your task3: Demodulation---write the missing codes------%
% Demodulate the signal after BPF
Ts = 1/Fs;
t=0:Ts:(N-1)*Ts;    % time index for the carrier 
rx_wave_baseband=rx_wave_BPF.*cos(2*pi*freq*t);  % demodulation 
% note: rx_wave_BPF is in time domain

sp_rx_wave_baseband = abs(fftshift(fft(rx_wave_baseband))); % its spectrum 
 
subplot(5,1,4); plot(f,sp_rx_wave_baseband);
% plot amplitude spectrum of rx_wave_baseband, in Hz

title('Amplitude spectrum of the demodulated signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
  


%--your task4: Apply LPF---write the missing codes-------%
% Design a suitable LPF to obtain the baseband speech signal
 
w=w1 ;    % w is the cutoff freq. of LPF, express w in terms of w1
rx_speech=lowpass(rx_wave_baseband,w);   % LPF with cutoff freq. w
%function lowpass is provided , it is a LPF.
%rx_speech, signal after LPF, in time domain
 
sp_rx_speech= abs(fftshift(fft(rx_speech))); % amplitude spectrum of rx_speech

subplot(5,1,5); plot(f,sp_rx_speech); %plot amplitude spectrum rx_speech in Hz

title('Amplitude sprectrum of speech signal (baseband)');
xlabel('Frequency (Hz)'); ylabel('Magnitude');
