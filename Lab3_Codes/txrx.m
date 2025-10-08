function rx_wave = txrx(tx_wave, distance, channel)
%TXRX    transmit and receive over ELEC1200x channel
%   RX_WAVE = TXRX(TX_WAVE) returns the output of a channel in response to
%   the input waveform TX_WAVE as the vector RX_WAVE with the same size as
%   TX_WAVE.
%
%   RX_WAVE = txrx(TX_WAVE,DIST) assumes the transmitter and receiver are
%   separated by a distance DIST (DEFAULT 10)
%
%   RX_WAVE = txrx(TX_WAVE,DIST,CHANNEL) sets the properties of the 
%   CHANNEL as follows:
%       'asynch' : exponential, low noise, asynch (DEFAULT)
%       'sync' : exponential, low noise, sync
%       'doubleexp' : double exponential, low noise, sync
%       'noisy' : exponential, high noise, async
%       'ideal' : ideal, no noise, sync
%   For the synchronous channels, tx_wave and rx_wave have the same size
%   and the samples are aligned.  For the asynchronous channels, there is a
%   random time offset between rx_wave and tx_wave.  The size of rx_wave is
%   larger than tx_wave and rx_wave always contains the response of the
%   channel during the time that tx_wave is being transmitted.

% global variables 
% for all channels
global elec1200_a1 elec1200_a2 
% for noisy channel
global elec1200_start_ind elec1200_rx_min elec1200_rx_max elec1200_sigma 

if nargin < 3,
    channel = 'async';
end
if nargin < 2, 
    distance = 10;
end
if nargin < 1,
    error('tx_wave must be defined');
end
band_noise=0;
% set channel parameters depending upon channel
switch channel
    case 'async' % exponential, low noise, asynch
        elec1200_a1 = 0.93;
        elec1200_a2 = 0;
        c = 0.3-0.1*exp(-distance/30);
        k = 60/distance^2;
        noise = 0.003;
        d1 = randi(200,1);
        d2 = randi(200,1);
    case 'sync' % exponential, low noise, synch
        elec1200_a1 = 0.93;
        elec1200_a2 = 0;
        c = 0.3-0.1*exp(-distance/30);
        k = 60/distance^2;
        noise = 0.007;
        d1 = 0;
        d2 = 0;
    case 'doubleexp' % double exponential, low noise, asynch
        elec1200_a1 = 0.89;
        elec1200_a2 = 0.78;
        c = 0.3-0.1*exp(-distance/30);
        k = 60/distance^2;
        noise = 0.0015;
        d1 = 0;
        d2 = 0;
    case 'noisy' % exponential, high noise, asynch
        elec1200_a1 = 0.93;
        elec1200_a2 = 0;
        c = 0.35-0.1*exp(-distance/30);
        k = 15/distance^2;
        noise = sqrt(0.001);
        d1 = randi(200,1);
        d2 = randi(200,1);
    case 'ideal' % ideal channel, synch
        elec1200_a1 = 0;
        elec1200_a2 = 0;
        c = 0;
        k = 1;
        noise = 0;
        d1 = 0;
        d2 = 0;
   case 'occupied_band' % channel with noise below 10kHz/above 70kHz (Fs=200kHz)
        elec1200_a1 = 0;
        elec1200_a2 = 0;
        c = 0;
        k = 1;
        noise = 0;
        d1 = 0;
        d2 = 0;
        N = length(tx_wave);
        band_noise = 0.2*randn(1,N);
        noise_fft = fft(band_noise);
        freq = fftfreq(N);
        Fs = 200e3;
        ind = (abs(freq) >= 10e3/Fs) & (abs(freq) <= 70e3/Fs);
        noise_fft(ind) = 0;
        band_noise = real(ifft(noise_fft));
    case 'pureexp' % exponential, low noise, synch
        elec1200_a1 = distance;
        elec1200_a2 = 0;
        c = 0;
        k = 1;
        noise = 0;
        d1 = 0;
        d2 = 0;
end

% simulate asynchronous channel with random delays before and after
tx_wave = [zeros(1,d1) tx_wave zeros(1,d2)];

%initialize rx_wave;
lrx = length(tx_wave);
rx_wave = zeros(1,lrx);

% LTI part of channel;
rx_wave(1) = k*(1-elec1200_a1)*tx_wave(1); % initialize recursion
for n=2:lrx,
    rx_wave(n)= elec1200_a1*rx_wave(n-1)+k*(1-elec1200_a1)*tx_wave(n);
end
rx_wave(1) = (1-elec1200_a2)*rx_wave(1); % initialize recursion
for n=2:lrx,
    rx_wave(n)= elec1200_a2*rx_wave(n-1)+(1-elec1200_a2)*rx_wave(n);
end

% add constant offset
rx_wave = rx_wave + c;

% set ground truth global variables for large noise channel
if strcmp(channel,'noisy') 
    elec1200_start_ind = find_start(tx_wave,0);
    elec1200_rx_min = min(rx_wave);
    elec1200_rx_max = max(rx_wave);
    elec1200_sigma = noise;
else
    elec1200_start_ind = [];
    elec1200_rx_min = [];
    elec1200_rx_max = [];
    elec1200_sigma = [];    
end

% add noise
iid_noise = noise*randn(1,lrx);
N = 4; % width of box filter
weight = 1/sqrt(N);
filtered_noise = zeros(1,lrx);
for n = 1:min((N-1),lrx),
    filtered_noise(n) = weight*sum(iid_noise(1:n));
end
for n = N:lrx,
    filtered_noise(n) = weight*sum(iid_noise((n-N+1):n));
end
rx_wave = rx_wave + filtered_noise + band_noise;



