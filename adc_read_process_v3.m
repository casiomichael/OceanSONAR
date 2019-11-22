% close all; 
clear all;
close all;

Fs = 250000;%\exp1_online\pi2
%% NEW
    %Convolution of Bandpassed Square Pulse w/ Bandpassed Data Calculated Above
       
     %% Creation of the Square Wave
        dt = 1/Fs; % seconds per sample 
        F = 30000; % Sine wave frequency (hertz) 
        num_pulses = 11; %Number of Pulses for the Square Wave
        T = num_pulses*1/F ;
        %% Init Signal
        % time step for one time period 
        tt = 0:dt:T+dt;
        signal = sin(2*pi*F*tt) ;
        rectsignal = sign(signal).*1;
        %% Padding the Square Wave for Clarity
        pad_pulse = 10;
        pad_T = pad_pulse*1/F + T;
        pad_tt = tt(length(tt)):dt:pad_T+dt;
        padding = zeros(1, length(pad_tt));
        rectsignal = horzcat(rectsignal, padding);
        tt = horzcat(tt, pad_tt);
        
        %The Bandpassed Square Wave
        bped2 = bandpass(rectsignal, [26500,33500], Fs);
        
        %Plotting the Square Wave
       
        figure(5)
        plot(tt, bped2)
        title('Current bandpass 26500-33500')

%% file
%CHANGE FIlE LOCATION
data_folder = '191121_rpi4-tests';    % change to whatever set of data you are trying to analyze
data_dir = fullfile('data',data_folder);
all_files = dir(data_dir);   
file_names = {all_files.name};
has_dot = contains(file_names,'.');
file_names(has_dot) = [];    % parses out all items that have a dot in it, including '.' and '..'
output_path = strcat('outputs\',data_folder);   % defines the folder the output folder we will save stuff to
%% data
 for curr_file = file_names
    %CHANGE FIlE LOCATION
    curr_file_str = char(curr_file);                    % need to do this because fread can't understand cell types
    fname = strcat(data_dir,'\',curr_file_str);        % char(curr_file) changes curr_file from a cell type to char
    mkdir(strcat(output_path,'\',curr_file_str));     % make director to where we're going to store all graphs for each test file
    fileID = fopen(fname);  
    A = fread(fileID, 'int16');
    
    %% ADDED BY FALL 2019 SONAR GROUP 
    % this small portion creates a figure for the raw file
    h = figure('visible','on');
    figure(4);
    plot(A);
    raw_title = strcat('Raw Data for\_',curr_file_str);
    title(raw_title);
    ylabel('bits (in decimal)');
    xlabel('samples per second'); % tbh not entirely sure, we think this is what Dr. Brooke told us
    saveas(gcf, fullfile(output_path,curr_file_str,strcat(curr_file_str, '_raw.png')))
    
    
    %% done by fall 2018 group
    for i=1:1:length(A)
       if A(i)>bitsll(1,14)
    %        A(i)=bitor(A(i),bitsll(1,16));
            A(i)=A(i)-bitsll(1,15);
       end
    end

    % % A=bitand(A,32767);
    % figure(4);clf
    % plot(A); 

    bpA = processdata(A,Fs,curr_file_str,output_path);    %    mainly uses this for naming purposes, which is why we dont use fname


    L = length(bpA);
    time = (0:(L-1))*(1/Fs);

    FFTA = fft(bpA); fftshift(FFTA);

    P2 = abs(FFTA/L);
    P1 = P2(1:round(L/2+1));
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;

    h = figure('visible', 'on');
    figure(2);
    plot(P1);
    pt = strcat('Single-Sided Amplitude Spectrum of Output of ADC_', curr_file_str);
    title(pt, 'Interpreter', 'none'); 
    xlabel('f (Hz)');
    ylabel('magnitude');
    
    %CHANGE FIlE LOCATION
     saveas(gcf, fullfile(output_path,curr_file_str,strcat(curr_file_str, '_SSAS.png')));  

      %% Convolution
        ConVD = conv(P1,bped2);
        
        %Plotting and Saving
        h1 = figure('visible', 'on');        
        figure(6);
        plot(ConVD);
        xlabel('f (Hz)');
        ylabel('magnitude');
        str = strcat('Convolved Square Pulse Train and Processed Data for ', curr_file_str);
        title(str); 
        saveas(gcf, fullfile(output_path,curr_file_str,strcat('Convolved Square Pulse Train and Processed Data for', curr_file_str, '.png')));

      %break
 end

fclose('all');
      





% decimal = decimal/(2^16);

% 
% % concat all rows next to each other
% % find the number in decimal
% % divide that by the max it can be 2^16
% % multiply by (Vmax-Vmin)