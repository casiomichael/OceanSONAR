function [ bped ] = processlakedata(data,fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



L = length(data); %number of samples
fc = 40000; %bandlimit
Ts = 1/fs; %sampling period
k = fc * Ts * L;
fsig = 20000; %fsignal
speed_of_sound = 4921.25984; %ft/s
%speed_of_sound = 1500; %m/s

t11 = [0: Ts: 11/fsig];
t_zero_pended = (0: fs-1)*Ts;
sqr_11 = square(2*pi*fsig*t11); 
%figure(1); plot(t11,2.5+2.5*sqr_11); 
% title('The Impulse Generated at the Arduino');
% xlabel('Time (s)'); ylabel('Voltage (V)');
sqr_11_zero_pended = [sqr_11, zeros(1,200000-74)];
%figure; plot(t_zero_pended,sqr_11_zero_pended);
%xlabel('Time (s)');
%
sqr_11_zero_pended = bandpass(sqr_11_zero_pended, [19700,20300], fs);

% figure(2); plot(sqr_11_zero_pended); 
% title('Simulation of the Bandpassed Signal Transmitted from Transducer');
% xlabel('Samples (n)'); ylabel('Voltage (V)');
% figure; plot(t_zero_pended,sqr_11_zero_pended); 
% title('The Soundwave Transmitted from Transducer');
% xlabel('Time (s)'); ylabel('Amplitude (V)');


% Choose the case you would like to examine from below
% see the output of DAQ for different distances betw the transducer and hydrophone

log_data = data; %column to get = the log number - 2
t = (0:L-1)*Ts;
% figure(3); plot(t,log_data); 
% title('Output of DAQ when transducer and hydrophone are 0.66 ft away'); 
%xlabel('Time (s)'); ylabel('Voltage (V)');
% log_data = july9LakeLog(:,3);
% t = (0:L-1)*Ts;
% figure; plot(t,log_data); title('Output of DAQ when transducer and hydophone are 1.32 ft away'); 
% xlabel('Time (s)'); ylabel('Amplitude (V)');
% log_data = july9LakeLog(:,4);
% t = (0:L-1)*Ts;
% figure; plot(t,log_data); title('Output of DAQ when transducer and hydophone are 2.64 ft away'); 
% xlabel('Time (s)'); ylabel('Amplitude (V)');
% log_data = july9LakeLog(:,5);
% t = (0:L-1)*Ts;
% figure; plot(t,log_data); title('Output of DAQ when transducer and hydophone are 5.28 ft away'); 
% xlabel('Time (s)'); ylabel('Amplitude (V)');
% log_data = july9LakeLog(:,6);
% t = (0:L-1)*Ts;
% figure; plot(t,log_data); title('Output of DAQ when transducer and hydophone are 10.56 ft away'); 
% xlabel('Time (s)'); ylabel('Amplitude (V)');
% %%%%%%%

% Process one of the above
% Filtering
bped = bandpass(log_data, [29700,30300], fs); 
figure(2); plot(t, bped);
title('Output of DAQ After Bandpass Filtering'); 
xlabel('Time (s)'); ylabel('Voltage (V)');

% % Only to check the magnitude values in the data
% peaks_indexes = zeros(1,30);
% peaks_values = zeros(1,30);
% j = 1;
% for i = 1:200000:L-200000
%     temp = bped( i: i+200000-1, 1);
%     [temp_max, index_max] = max(temp);
%     peaks_indexes(j) = index_max + (i-1); %correct
%     peaks_values(j) = bped(peaks_indexes(j)); %correct
%     j = j+1;
% end

% Convolution5x
% conv_bped = conv( bped, sqr_11_zero_pended);
% L_conv = length(conv_bped);
% t_conv = (0:(L_conv-1))*Ts;
% % figure(5); plot(t_conv,conv_bped); 
% % title('Convolution of Bandpassed DAQ Output and Transmitted Impulse');
% % xlabel('Time (s)'); ylabel('Voltage^2 (V^2)');
% 
% %CDF to decide on the magnitude threshold
% sorted = sort(conv_bped); %same length as L_conv
% CDF_conv = zeros( 1, L_conv);
% for i=1:length(sorted)
%     CDF_conv(i) = (i-1)/L_conv;
% end
% % figure(6); plot(sorted, CDF_conv); title('CDF of Convolved and Bandpassed Signal');
% % xlabel('Result of Convolution (V^2)');ylabel('Cumulative Probability');
% % ylim([-0.2 1.2]); %xlim([-80 80]);
% 
% threshold = 0.2; %decide by looking at the CDF. e.g. take the x when y=0.99
% thr_applied = conv_bped; %apply threshold to convolved and bandpassed data
% for i=1:L_conv
%     if (conv_bped(i) > -1*threshold && conv_bped(i) < threshold)
%         thr_applied(i) = 0; %eliminates the values < |threshold|
%     end
% end 
% % figure(7); plot(t_conv, thr_applied);
% % title('Applying a Magnitude Threshold to the Result of Convolution');
% % xlabel('Time (s)'); ylabel('Voltage^2 (V^2)');
% 
% % Zoom in on the Simulation of Transmitted Convolution figure
% % the waves after approximately 100 samples
% % Zoom in on the Output of Daq after Bandpass Filtering
% % again a wave builds up and dies out in aprox 100 samples
% % convolution of these two results in a length 100+100-1 = 199 ~200
% window_length = 100;
% 
% % Now find the max of each 200 samples. That peak  should show
% % the source point of the sound wave
% window_applied = zeros(L_conv, 1); % start with all 0 values
% % cur_window = thr_applied(1:window_length);
% % [cur_max,index] = max(cur_window);
% % window_applied(index) = cur_max; 
% 
% for i = 1: 1: L_conv-window_length+1 %look in pieces of window length
%     cur_window = thr_applied( i: i+window_length-1, 1);
%     [cur_max,index] = max(cur_window);
%     index = index + i - 1;
%     % Now make only the max of these 200 samples nonzero
%     window_applied( i: i+window_length-1, 1) = zeros(window_length,1);
%     window_applied(index) = cur_max;
% end
%  
% 
% peaks_indexes = zeros(1,30);
% peaks_values = zeros(1,30);
% j = 1;
% for i = 1:fs:L_conv-fs %fs is the number of samples in 1 sec which can have at most one ping
%     temp = window_applied( i: i+200000, 1);
%     [temp_max, index_max] = max(temp);
%     peaks_indexes(j) = index_max + (i-1); %correct
%     peaks_values(j) = window_applied(peaks_indexes(j)); %correct
%     j = j+1;
% end
% 
% each_sec_a_col = zeros(360000,30); %initially make a big matrix to avoid indexing issues later
% 
% for i=1:29
%     each_sec_a_col(1:(peaks_indexes(i+1)-peaks_indexes(i)),i) = window_applied(peaks_indexes(i):peaks_indexes(i+1)-1);
% end
% each_sec_a_col(1:L_conv-peaks_indexes(30)+1,30) = window_applied(peaks_indexes(30):L_conv,1);
% 
% figure(10);
% x_axis = (0:(length(each_sec_a_col)-1))*Ts*speed_of_sound/2;


end

