function [SIGNAL,f]=fast_fourier_transform(signal,dt,dim);

% Input:
%	signal	:	Vector containing the time series to be transformed
%	dt	:	Sampling rate in s
%
% Output:
%	SIGNAL	:	Vector containing the Fourier coefficients
%	f	:	Frequency vector
%
% ---------
%
% Lisa Groos, 2013


SIGNAL=dt*fftshift(fft(signal,[],dim),dim);
ns=length(signal);	% Number of samples
f=[-fix(ns/2):1:ceil(ns/2)-1]/(ns*dt); 	% Vector containing frequencies

if (size(signal,1)~=1)	% Signal was passed in a column vector
	f=f';
end
