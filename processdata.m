function [ bped ] = processdata(data,fs, file_name,output_path)

L = length(data); %number of samples
Ts = 1/fs; %sampling period

log_data = data; %column to get = the log number - 2
t = (0:L-1)*Ts;

% Filtering
bped = bandpass(log_data, [26500,33500], fs); 
h = figure('visible', 'on'); figure(3); plot(t, bped);
save(strcat('mat',file_name,'data'), 'bped')
plot_title = strcat('Output of DAQ After Bandpass Filtering_', file_name);
title(plot_title, 'Interpreter', 'none'); 
xlabel('Time (s)'); ylabel('Voltage (V)');
saveas(gcf, fullfile(output_path,file_name,strcat(file_name,'_bandpass.png')));

dt = 1/fs; % seconds per sample 
F = 30000; % Sine wave frequency (hertz) 
num_pulses = 11;
T = num_pulses*1/F ;

%% Init Signal
% time step for one time period 
tt = 0:dt:T+dt;
signal = sin(2*pi*F*tt) ;
rectsignal = sign(signal).*1;

%% Padding
pad_pulse = 10;
pad_T = pad_pulse*1/F + T;
pad_tt = tt(length(tt)):dt:pad_T+dt;
padding = zeros(1, length(pad_tt));
rectsignal = horzcat(rectsignal, padding);

bped2 = bandpass(rectsignal, [26500,33500], fs);

test = conv(bped, bped2);
figure (1)
newdom = (0:length(test)-1)*Ts;
h = figure('visible', 'on'); plot(newdom, test);
plot_title = strcat('Convolved Data_', file_name);
title(plot_title, 'Interpreter', 'none'); 
xlabel('Time(s)')
saveas(h, fullfile(output_path,file_name,strcat(file_name,'_conv.png')));

end

