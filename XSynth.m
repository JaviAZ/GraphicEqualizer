function [z, fs] = XSynth(x, fsx, y, fsy)

% Get average in case of multiple channels
x = mean(x, 2);
y = mean(y,2);
% make x and y with equal sampling rate
fs = max(fsx, fsy);
if fsx > fsy
    y = resample(y, fsx, fsy);
else
    x = resample(x, fsy, fsx);
end
% make x and y with equal length
xlen = length(x);
ylen = length(y);
if xlen > ylen
    x = x(1:ylen);
else
    y = y(1:xlen);
end
% define the analysis and synthesis parameters
wlen = 1024;
hop = wlen/4;
nfft = wlen;
% perform time-frequency analysis
[X_stft, f] = stft(x, wlen, hop, nfft, fs);
[Y_stft, ~] = stft(y, wlen, hop, nfft, fs);
% memory optimization
clear x y
% extract spectral envelope of the carrier signal
X_stft_amp = abs(X_stft);
for k = 1:size(X_stft_amp, 2)
    X_env(:, k) = specenv(X_stft_amp(:, k), f);
end
% extract spectral envelope of the modulating signal
Y_stft_amp = abs(Y_stft);
for k = 1:size(Y_stft_amp, 2)
    Y_env(:, k) = specenv(Y_stft_amp(:, k), f);
end
% memory optimization
clear X_stft_amp Y_stft_amp Y_stft
% cross-synthesis
Z_stft = X_stft./X_env.*Y_env;
z = istft(Z_stft, wlen, hop, nfft, fs);
% memory optimization
clear X_stft Z_stft X_env Y_env