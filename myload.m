load ('100m.mat')          % the signal will be loaded to "val" matrix
val = (val - 1024)/200;    % you have to remove "base" and "gain"
ECGsignal = val(1,1:1000); % select the lead (Lead I)
Fs = 360;                  % sampling frequecy
t = (0:length(ECGsignal)-1)/Fs;  % time
plot(t,ECGsignal)