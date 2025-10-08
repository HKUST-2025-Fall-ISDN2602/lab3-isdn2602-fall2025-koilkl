function y = fftfreq(n)
%FFTFREQ frequencies of the N point FFT.
%	FFTFREQ(N) returns an N dimensional vector containing the N 
%	normalized frequencies of the N point FFT.
%   Zero frequency is at position one.

n2 = floor(n/2);
if (n/2 == n2)		% even
    y = [ 0:(n2-1) (-n2):(-1) ]/n;
else			% odd
    y = [ 0:n2 -n2:-1 ]/n;
end