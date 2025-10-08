function tx_wave = modulate_task3(x, Fs)

x=lowpass(x,Fs,4e3); 
% modulate the carrier wave using x
tx_wave = modulate(x,Fs,10e3);

