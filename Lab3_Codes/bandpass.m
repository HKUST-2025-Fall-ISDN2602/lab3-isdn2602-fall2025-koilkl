function output_wave=bandpass(input_wave, high_freq, low_freq, Fs)

Filter_Order = 200;                         % Set filter order to be 128
BCoeff_BPF = fir1(Filter_Order, [(low_freq)*(2/Fs) (high_freq)*(2/Fs)],'bandpass');
H = freqz(BCoeff_BPF,[1],'whole');
F=(-256:255)*Fs/512;
% figure()
% plot(F, abs(fftshift(H)));
% title('Frequency Response of the Band Pass Filter');
% xlabel('Frequency (Hz)');
% ylabel('Magnitude');

output_wave=filter(BCoeff_BPF,[1],input_wave);
