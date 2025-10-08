function x = equalizer(y,a)
% EQUALIZER equalize first order channel
%   X = EQUALIZER(Y,A) applies an equalizer to the channel output Y and
%   returns the result as a vector X with the same size as Y.
%   The input/output relation of the channel is assumed to be described by
%       Y(N) = A*Y(N-1) + (1-A)*X(N)


len_y = length(y);  % find length of input
x = zeros(1,len_y); % initialize output to size of input
x(1) = y(1);        % assume y(0)=y(1);
for n=2:len_y
    x(n)=(y(n)-a*y(n-1))/(1-a);    
end
