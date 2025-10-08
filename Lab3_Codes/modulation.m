function [tx_wave]=modulation(speech1, speech2, speech3)
Fs=1e5;

% (b) Low pass speech1, speech2 and speech3 using the designed %
%     filter                                                   %
%     Plot out the Fourier amplitudes of the lowpass filtered  %
%     signals as a function of frequency as three subplots     %
%     of a figure                                              %
% Write your code here                                         %

speech1_LPF=lowpass(speech1,4000);
speech2_LPF=lowpass(speech2,4000);
speech3_LPF=lowpass(speech3,4000);

% without low pass filtering 
%speech1_LPF=speech1;
%speech2_LPF=speech2;
%speech3_LPF=speech3;

f=[-length(speech1)/2:length(speech1)/2-1]*(Fs/length(speech1));

figure(2)
subplot(3,1,1)
plot(f, abs(fftshift(fft(speech1_LPF))));
title('Fourier amplitude of Speech1');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(3,1,2)
plot(f, abs(fftshift(fft(speech2_LPF))));
title('Fourier amplitude of Speech2');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(3,1,3)
plot(f, abs(fftshift(fft(speech3_LPF))));
title('Fourier amplitude of Speech3');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (c) multiply the speech data by cosine function to shift the %
%     signal to higher frequency bands                         %
%     (speech1-10kHz, speech2-20kHz, speech3-30kHz)            %
%     Plot out the Fourier amplitudes of the signals in three  %
%     separate subplots of figure (3)                          %
% Write your code here                                         %
t=0:length(speech1)-1;
speech1_LPF_modulate=speech1_LPF.*cos(2*pi*1e4*t/Fs);
speech2_LPF_modulate=speech2_LPF.*cos(2*pi*2e4*t/Fs);
speech3_LPF_modulate=speech3_LPF.*cos(2*pi*3e4*t/Fs);

figure(3)
subplot(3,1,1)
plot(f, abs(fftshift(fft(speech1_LPF_modulate))));
title('Fourier amplitude of modualted Speech1');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(3,1,2)
plot(f, abs(fftshift(fft(speech2_LPF_modulate))));
title('Fourier amplitude of modualted Speech2');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(3,1,3)
plot(f, abs(fftshift(fft(speech3_LPF_modulate))));
title('Fourier amplitude of modualted Speech3');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% (d) Combine the three modulated waveforms together           %
%     Plot out Fourier amplitude of the resulting signal in    %
%     figure (4)                                               %
% Write your code here                                         %
tx_wave=speech1_LPF_modulate+speech2_LPF_modulate+speech3_LPF_modulate;
figure(4);
plot(f, abs(fftshift(fft(tx_wave))));
title('Fourier amplitude of combined signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
