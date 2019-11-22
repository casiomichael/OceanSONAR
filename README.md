# OceanSONAR

This Ocean SONAR project is an ongoing class project (ECE 461) at Duke University. 

This repository organizes the MATLAB code worked on by the SONAR Signal Processing Group in Fall 2018. Changes to the MATLAB code were done to make signal processing easier for future groups that may work on this. 

This repository is organized as follows: There are two main folders of interest: data and outputs. 

The data folder contains all raw data that is collected from the Raspberry Pis. Please note that the Raspberry Pis save the data as .gz files. These needs to be gunzipped. When using the RPi 3 configuration (see Fall 2019 Report), we encountered problems where the terminal is unable to gunzip the .gz files because it cannot find the end-of-file. We found that 7-zip was an effective tool that can uncompress the data. Inside the data folder includes the folder of each set of data. This has the naming convention of YYMMDD_test-name for ease and organization. Feel free to name your folders anyway you want. The raw data goes in each of the folders.

With the outputs folder, you don't need to mess around with it. The MATLAB script takes care of saving all graphs in this directory. The organization is similar to the data folder. The first level is the name of the test, while the second level is the name of each raw data file. This second folder should contain five graphs that show different signal processing done to the data. It should also include a plot of the raw data. 

The main MATLAB script that needs to be ran is adc_read_process_v3.m. The only variable that needs to be changed is the data_folder variable. This is a string that is the name of the folder that you stored your data in. At the time that this README was written, the data_folder variable was set to 191121_rpi4-tests. This is all you pretty much need to change to print out the graphs. The only time that you'd mess around with this script some more is if you were going to add more signal processing code. 

One thing that you would probably notice when running this program is that a whole bunch of .mat files start showing up on the main directory. I'm not entirely sure why that happens, but the data isn't needed and you can just delete it. The main data you are concerned about are the graphs produced. 

Regarding what's in the rest of this repository, there are three other MATLAB scripts available. processdata.m and bandpass.m are both just functions written, which are called in the main adc_read_process_v3 scripts. The other script, called test-raw.m, was used to do quick tests on how our raw files looked. Simply just change the string being read to the name of the data you want to plot. Please note that the raw data file must be in the main directory and NOT in data for raw-tests.m to work. It does not have the changing of directory that adc_read_process_v3.m has.

