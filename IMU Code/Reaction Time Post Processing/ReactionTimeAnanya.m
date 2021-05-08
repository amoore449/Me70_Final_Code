% -----------------------------------------------------------------------
% IMU Post-processing 
% Participant: Ananya
% -----------------------------------------------------------------------

clear
close all

%Loop through each of the 3 distraction modes (d)
for d = 1:3
%Loop through each of the different trails (t) for each distraction mode
for t = 1:3
    %Read in data for time that the stop sign switched on
    trial_times = readtable('StopSignTimes.xlsx');
    %Depending on the distraction and trial, read in IMU data file and
    %specific stop sign time data
    if t == 1
        if d == 1
            Data = readtable('Trial01A_Ananya_AccelerationX.xlsx');
            trial_time = table2array(trial_times(12,[2:5]));
        end
        if d == 2
            Data = readtable('Trial01B_Ananya_AccelerationX.xlsx');
            trial_time = table2array(trial_times(13,[2:5]));
        end
        if d == 3
            Data = readtable('Trial01C_Ananya_AccelerationX.xlsx');
            trial_time = table2array(trial_times(14,[2:5]));
        end 
    end
    if t == 2
        if d == 1
             Data = readtable('Trial02A_Ananya_AccelerationX.xlsx');
             trial_time = table2array(trial_times(15,[2:5]));
        end
        if d == 2
            Data = readtable('Trial02B_Ananya_AccelerationX.xlsx');
            trial_time = table2array(trial_times(16,[2:5]));
        end
        if d == 3
            Data = readtable('Trial02C_Ananya_AccelerationX.xlsx');
            trial_time = table2array(trial_times(17,[2:5]));
        end 
    end
    if t == 3
        if d == 1
             Data = readtable('Trial03A_Ananya_AccelerationX.xlsx');
             trial_time = table2array(trial_times(18,[2:5]));
        end
        if d == 2
            Data = readtable('Trial03B_Ananya_AccelerationX.xlsx');
            trial_time = table2array(trial_times(19,[2:5]));
        end
        if d == 3
            Data = readtable('Trial03C_Ananya_AccelerationX.xlsx');
            trial_time = table2array(trial_times(20,[2:5]));
        end 
    end

%Extract the elements of start time for the IMU data - the start time
%represents the global time at which the IMU started collecting data
start_hr = table2array(Data(1,3));
start_min = table2array(Data(1,4));
start_sec = table2array(Data(1,5));

%Display the start time for both the IMU data and the stop sign switching
%data for troubleshooting purposes (no longer necessary)

%IMU starting time
"Starting time: "+string(start_hr)+":"+string(start_min)+":"+string(start_sec);

%Matlab code controlling stop sign switching start time (we realized the 
%computer running this code during the trials had a time that was ahead of
%the computer running the Labview IMU code by about 97 seconds so we
%account for this later in the code)
"Trial time: "+string(trial_time(2))+":"+string(trial_time(3))+":"+string(trial_time(4));

%Calculate global time in milliseconds that the stop sign switching to red
%(subtract 97 seconds to account for error in computer time)
stopSign = (((trial_time(2)*3600+trial_time(3)*60+trial_time(4))+trial_time(1))-97)*1000;

%Find IMU starting time in milliseconds 
start_time = (start_hr*3600+start_min*60+start_sec)*1000;

%Take in rest of data from IMU file
time = Data(:,1);  %take the first column from the file (time)
time = table2array(time); %create an array from the values
time = time*10; %convert time data to milliseconds

accelerationX = Data(:,2); %take in second column from file (acceleration)
accelerationX = table2array(accelerationX); %create an array from the values

%Save raw acceleration data as a variable (before trying to smooth out
%noise and account for drift
raw_accelerationX = accelerationX;


%Try to smooth out the noise and account for drift

%Choose threshold value based on the data - this value was chosen after
%looking at the data
threshold = 0.7;

%Loop through the acceleration data
for i = 1:2:length(accelerationX) - 10
    %compare the acceleration value to the next 10 acceleration values in
    %the array - if the difference between the value and any of the next
    %values is less than the threshold, set all of the acceleration values
    %to zero (to account for the drift due to the IMU)
    if (abs(accelerationX(i) - accelerationX(i+1:i+10)) < threshold) 
            %Save the current index to a new noAccelerationIndices array
            %(for troublshooting purposes)
            noAccelerationIndices(i) = i;
            %Set the acceleration values to zero
            accelerationX(i:i+10) = 0;
    end
end

%Loop through the noAccelerationIndices array
for i = 1:length(accelerationX)-50
    %If 50 data points in a row are all zero, then assume that the
    %participant is stopped and append a 1 to the stop boolean array
    if accelerationX(i) == accelerationX(i+1:i+50)
        stop(i) = 1;
    end
end

%Switch array to column
stop = stop';       

%Plot acceleration data and stop boolean data of each trial for each
%distraction method
figure(d)
%Change title of figure depending on d
if d == 1
    sgtitle("No Distraction (Ananya)")
end
if d == 2
    sgtitle("Texting Distraction (Ananya)")
end
if d == 3
    sgtitle("Gaming Distraction (Ananya)")
end

%Plot raw and thresholded acceleration data
subplot(2,3,t)
hold on
plot(time,raw_accelerationX)
plot(time,accelerationX) 
legend('Raw Acc', 'Thresholded Acc')
xlabel('Time (ms)')
ylabel('Acceleration (m/s)')
xlim([0 time(end)])

%Filter through stop boolean array to get rid of some of the noise - since
%the stop periods are relatively long if the data does not indicate a stop 
%for more than 50 points, assume this was not a true stop
for i = 1:length(stop)-70
    if stop(i) == 0 && stop(i+1) == 1
        for j = 2:50
            if stop(i+1) ~= stop(i+j)
                stop(i+1:i+70) = stop(i);
                break
            end
        end
    end
end

%Plot the stop boolean array
subplot(2,3,t+3)
plot(time(1:length(stop)), stop, 'LineWidth',6)
title('Stopped')
xlabel("Time (ms)")
xlim([0 time(end)])

%Based on acceleration plots, hard code a loop value that occurs while
%participant is walking (before stop event). The stop boolean data is not
%perfect so this just ensures that the correct stop is picked up (this step
%was done after looking at data)
if d == 3 && t == 3
    beforeStop = 800;
else 
    beforeStop = 500;
end

%Calculate the time elapsed from the start of the IMU data to the
%approximated stop time
for i = beforeStop:length(stop)
    if stop(i) == 1
        elapsed_time = time(i);
        break
    end
end

%Calculate the global stop time of the particpant according to the IMU data
stopTime = start_time + elapsed_time;

%Calculate the difference between the stop sign red time to the stop time
%of the participant in seconds
timeDifference = abs(stopSign - stopTime)/1000;

%Append these times to an array depending on the current distraction and
%trial
if d == 1
    timeDifferenceArray(t) = timeDifference;
end
if d == 2
   timeDifferenceArray(3+t) = timeDifference;
end
if d == 3
   timeDifferenceArray(6+t) = timeDifference;
end

%Clear almost all variables
clearvars -except trial_time d timeDifferenceArray

end
end

%Make timeDifferenceArray into a column
timeDifferenceArray = timeDifferenceArray'

%Calculate the mean of the time differences for each distraction method
timeDifferenceMeansA = mean(timeDifferenceArray(1:3));
timeDifferenceMeansB = mean(timeDifferenceArray(4:6));
timeDifferenceMeansC = mean(timeDifferenceArray(7:9));

%Append these means to new array
timeDifferenceMeans = [timeDifferenceMeansA timeDifferenceMeansB timeDifferenceMeansC]';

%Create bar graph showing means for each distraction method
figure(4)
hold on
title("Reaction Time for Different Distraction Conditions (Ananya)")
ylabel("Reaction Time (s)")
xlabel("Distraction Mode")
set(gca,'xticklabel',{"","","None","","Texting","","Gaming","",""})
bar(timeDifferenceMeans)
text(1:length(timeDifferenceMeans'),timeDifferenceMeans,num2str(timeDifferenceMeans),'vert','bottom','horiz','center'); 

%The time differences calculated were too large (likely due to the
%inaccuracy in the global time taken from different data collection
%sources) - therefore, the following code normalizes the data to the
%control trial and replots 
timeDifferenceMeansA_norm = timeDifferenceMeansA-timeDifferenceMeansA
timeDifferenceMeansB_norm = timeDifferenceMeansB-timeDifferenceMeansA
timeDifferenceMeansC_norm = timeDifferenceMeansC-timeDifferenceMeansA

timeDifferenceMeans_norm = [timeDifferenceMeansA_norm timeDifferenceMeansB_norm timeDifferenceMeansC_norm]';

%Plot of normalized reaction time mean data
figure(5)
hold on
title("Reaction Time for Different Distraction Conditions (Ananya)")
ylabel("Reaction Time (s)")
xlabel("Distraction Mode")
set(gca,'xticklabel',{"","","Control","","Texting","","Gaming","",""})
bar(timeDifferenceMeans_norm)
text(1:length(timeDifferenceMeans_norm'),timeDifferenceMeans_norm,num2str(timeDifferenceMeans_norm),'vert','bottom','horiz','center');


