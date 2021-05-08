%This is a script that scans the acceleration data that is in the range of
%the STOPLIGHT time, selects the three biggest and 3 smallest points, and
%outputs those values and their total average. 

%Given the x-value of highest acceleration and lowest acceleration, take
%the time difference of the two multiplied by the size of the time step!

Ananya = 1;
Olif = 0;
Allison = 0;

timeRange = .1; %seconds

%-----------------------
timeRange = timeRange * 1000; %ms conversion

if Ananya + Olif + Allison ~= 1
    disp('Only one of these should be set to 1!!')
    return
end
    
if Ananya == 1
    STOPLIGHT_stopTime = cell2mat(STOPLIGHT_timeMS(12:20, 2));
    STOPLIGHT_startTime = startTimeMS(12:20);
    
    threshold = 0.7;
    
end 
    
if Olif == 1
    STOPLIGHT_stopTime = cell2mat(STOPLIGHT_timeMS(1:9, 2));
    STOPLIGHT_startTime = startTimeMS(1:9);
    
    threshold = 0.7;
    
end

if Allison == 1
    STOPLIGHT_stopTime = cell2mat(STOPLIGHT_timeMS(22:30, 2));
    STOPLIGHT_startTime = startTimeMS(22:30);
    
    threshold = 0.7;
    
end
    
IMU_startTime = str2double(IMU_timeMS(:,2));

%Let's get stop time relative to the IMU!!

relIMUStopTime = (STOPLIGHT_stopTime - IMU_startTime);

%Get the the index!!
IMU_idx = round(relIMUStopTime/100); %each time step is 10 ms (divide by 1000 -> *10)!

maxIdx = IMU_idx + timeRange;
minIdx = IMU_idx - timeRange;

%Now get acceleration data...
%maxIDX is a vector of the start indices, minIDX is a vector of the stop
%indices. So collect this range from each Excel file

d = dir('Trial*.xlsx');
names = {d.name};

outputArray(1,1) = {'Trial Name'};
outputArray(1,2) = {'Max Accel'};
outputArray(1,3) = {'Max Accel Idx'};
outputArray(1,4) = {'Min Accel'};
outputArray(1,5) = {'Min Accel Idx increase from Max Accel Idx'};

for ii = 1:length(names)
    fileName = names{ii};
    
    IMUdata = readtable(fileName);
    IMUdata = table2array(IMUdata);
    
    %THIS SECTION IS FOR SMOOTHING THE ACCELERATION DATA!!
    accelerationX = IMUdata(:,2); %take in second column from file (acceleration)

    %Create new array of 50 point moving average to smooth data
    accelerationXMovingAverage = movavg(accelerationX, 'simple', 50); 
    
    %Save raw acceleration data as a variable (before trying to smooth out
    %noise and account for drift
    raw_accelerationX = accelerationX;
    
    %Try to smooth out the noise and account for drift

    %Choose threshold value based on the data - this value was chosen after
    %looking at the data
    threshold = threshold;
    
    
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

%Transition the variable back to IMUdata for simplicity:
    IMUdata(:,2) = accelerationX;

%     %since 10ms is at index 3, add 2 to each idx.
%     
%     maxIdx = maxIdx + 2;
%     minIdx = minIdx + 2;
%     
%     if maxIdx(ii) > max(IMUdata(:,1))
%         maxIdx(ii) = max(IMUdata(:,1));
%         disp ('Check to make sure this is not suspicious!')
%     end
%     
%     if minIdx(ii) < min(IMUdata(:,1))
%         disp ('Something is up...')
%     end
%     
%     dataOfInterest = IMUdata(minIdx:maxIdx, 1:2);
%     
%     %now collect the maximum and minimum acceleration values:
%     
%     maxAccel_IMU = max(dataOfInterest(:,2));
%     minAccel_IMU = min(dataOfInterest(:,2));

%% The previous code was giving some bugs due to our inability to time-align the two datasets.
% Here is our workaround! 


    [maxAccel_IMU, maxIdx] = max(IMUdata(:,2));
    searchIdx = maxIdx + timeRange; %We care about subsequent negative data, so search in this area...   
    
    disp(maxIdx)
    
    dataOfInterest = IMUdata(maxIdx:searchIdx, 1:2); %yes, these are supposed to be switched, don't worry!
    [minAccel_IMU, minIdx] = min(dataOfInterest(:,2));
    
    
    if maxIdx > max(IMUdata(:,1))
        maxIdx = max(IMUdata(:,1));
        disp ('Check to make sure this is not suspicious!')
    end
    
    if minIdx < min(IMUdata(:,1))
        disp ('Something is up...')
    end
    


%% End of Aside. Create the Output Array:

    outputArray(ii+1,1) = {fileName};
    outputArray(ii+1,2) = {maxAccel_IMU};
    outputArray(ii+1,3) = {maxIdx}; %see note above for +2 reasoning!
    outputArray(ii+1,4) = {minAccel_IMU};
    outputArray(ii+1,5) = {minIdx};

end


%%
%Now that we have our minimum and maximum acceleration data, we can see if
%it's statistically significant across groups. 

%Trial 01A, 02A, 03A are one group

A01_max = outputArray{2,2};
A02_max = outputArray{5,2};
A03_max = outputArray{8,2};

ATrials_max = [A01_max;A02_max;A03_max];

%Trial 01B, 02B, 03B are another group
B01_max = outputArray{3,2};
B02_max = outputArray{6,2};
B03_max = outputArray{9,2};

BTrials_max = [B01_max;B02_max;B03_max];

%Trial 01C, 02C, 03C are the last group

C01_max = outputArray{4,2};
C02_max = outputArray{7,2};
C03_max = outputArray{10,2};

CTrials_max = [C01_max;C02_max;C03_max];

[p,tbl,stats] = anova1([ATrials_max,BTrials_max,CTrials_max], {'None','Texting','Gaming'});
title('Maximum Acceleration, Ananya'); 


%Now all that's left is to analyze the ANOVA test!
multcompare(stats)
title('Maximum Acceleration, Ananya')

%% Do the same calculation but for the minimum acceleration value!

A01_min = outputArray{2,4};
A02_min = outputArray{5,4};
A03_min = outputArray{8,4};

ATrials_min = [A01_min;A02_min;A03_min];

%Trial 01B, 02B, 03B are another group
B01_min = outputArray{3,4};
B02_min = outputArray{6,4};
B03_min = outputArray{9,4};

BTrials_min = [B01_min;B02_min;B03_min];

%Trial 01C, 02C, 03C are the last group

C01_min = outputArray{4,4};
C02_min = outputArray{7,4};
C03_min = outputArray{10,4};

CTrials_min = [C01_min;C02_min;C03_min];

[p_min,tbl_min,stats_min] = anova1([ATrials_min,BTrials_min,CTrials_min], {'None','Texting','Gaming'});
title('Minimum Acceleration, Ananya')

figure
multcompare(stats_min)
title('Minimum Acceleration, Ananya')

%% Lastly, calculate jerk (delta accel/ delta t)

A01_jrk = (A01_max + A01_min)/(outputArray{2,5});
B01_jrk = (B01_max + B01_min)/(outputArray{3,5});
C01_jrk = (C01_max + C01_min)/(outputArray{4,5});
A02_jrk = (A02_max + A02_min)/(outputArray{5,5});
B02_jrk = (B02_max + B02_min)/(outputArray{6,5});
C02_jrk = (C02_max + C02_min)/(outputArray{7,5});
A03_jrk = (A03_max + A03_min)/(outputArray{8,5});
B03_jrk = (B03_max + B03_min)/(outputArray{9,5});
C03_jrk = (C03_max + C03_min)/(outputArray{10,5});


ATrials_jrk = [A01_jrk;A02_jrk;A03_jrk];
BTrials_jrk = [B01_jrk;B02_jrk;B03_jrk];
CTrials_jrk = [C01_jrk;C02_jrk;C03_jrk];

close all
[p_jrk,tbl_jrk,stats_jrk] = anova1([ATrials_jrk/10,BTrials_jrk/10,CTrials_jrk/10], {'None','Texting','Gaming'});
title('Acceleration/Time, Ananya')

disp(p_jrk)
disp(stats_jrk)

figure
multcompare(stats_jrk)
title('Acceleration/Time, Ananya')

%% Olif_03C; Ananya_02B were the ones cut!!



