function plotAmplitudeSpectrum(x,Fs,plot_title)

% compute amplitude spectrum
sp_x = abs(fftshift(fft(x))); % prefix 'sp' means spectrum

% Make frequency vector f 
f = Fs*1e-3*fftshift(fftfreq(length(x)));
			   	 
% Plot amplitude spectrum of x(t) 
plot(f,sp_x); grid on;      
axis([-Fs/2000 Fs/2000 0 1300]);
title(plot_title);  
xlabel('Frequency (kHz)');   
end