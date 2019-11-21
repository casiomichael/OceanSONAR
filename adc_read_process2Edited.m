% close all; 
clear all;

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
all_files = dir('/Users/benjackson/Documents/MATLAB/Oceans/dir-selected');
file_names = {all_files.name};
file_names = string(file_names(4:end));


%% data
 for curr_file = file_names
    fname = curr_file;
    %CHANGE FIlE LOCATION
    fileID = fopen(strcat('/Users/benjackson/Documents/MATLAB/Oceans/dir-selected/', curr_file));%mydata23%raw_unflipped
    A = fread(fileID, 'int16');

    for i=1:1:length(A)
       if A(i)>bitsll(1,14)
    %        A(i)=bitor(A(i),bitsll(1,16));
            A(i)=A(i)-bitsll(1,15);
       end
    end

    % % A=bitand(A,32767);
    % figure(4);clf
    % plot(A); 

    bpA = processdata(A,Fs,curr_file);


    L = length(bpA);
    time = (0:(L-1))*(1/Fs);

    FFTA = fft(bpA); fftshift(FFTA);

    P2 = abs(FFTA/L);
    P1 = P2(1:round(L/2+1));
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;

    h = figure('visible', 'off');
    figure(2)
    plot(P1);
    pt = strcat('Single-Sided Amplitude Spectrum of Output of ADC_', fname);
    title(pt, 'Interpreter', 'none'); 
    xlabel('f (Hz)');
    ylabel('magnitude');
    
    %CHANGE FIlE LOCATION
    fpath = '/Users/benjackson/Documents/MATLAB/Oceans/Outputs/';
     saveas(h, fullfile(fpath,strcat(fname, '_SSAS.png')));

      %% Convolution
        ConVD = conv(P1,bped2);
        
        %Plotting and Saving
        figure(7)
        plot(ConVD);
        xlabel('f (Hz)');
        ylabel('magnitude');
        str = strcat('Convolved Square Pulse Train and Processed Data for ', fname);
        title(str); 
        h1 = figure('visible', 'off');
        saveas(h1, fullfile(fpath,strcat('Convolved Square Pulse Train and Processed Data for', fname)));

      %break
 end

fclose('all');

 

      





% decimal = decimal/(2^16);

% 
% % concat all rows next to each other
% % find the number in decimal
% % divide that by the max it can be 2^16
% % multiply by (Vmax-Vmin)