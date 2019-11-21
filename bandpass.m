function out = bandpass(sig, f, fs)

d = fdesign.bandpass('N,F3dB1,F3dB2',10,f(1),f(2),fs);
Hd = design(d,'butter');

out = filter(Hd,sig);

