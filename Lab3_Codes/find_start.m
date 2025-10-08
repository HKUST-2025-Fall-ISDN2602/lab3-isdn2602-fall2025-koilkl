function start_ind = find_start(rx_wave)

rx_wave_eq = equalizer(rx_wave,0.93);
threshold = (max(rx_wave_eq)+min(rx_wave_eq))/2;

rx_threshold = rx_wave_eq > threshold;
up_transitions = find(diff(rx_threshold) > 0.5);
if length(up_transitions) < 2,
    error('find_start: start bit not found');
else
    start_ind = up_transitions(1)+1;
end
