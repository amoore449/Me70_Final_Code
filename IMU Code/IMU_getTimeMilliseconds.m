% IMU getTimeMilliseconds
% This is a script that runs inside the Trials folder.
% It looks at each person's IMU start time and converts them to MS.

%Run this for every person's data that we have.

%Let the user select the first folder, then nav there:
selpath = uigetdir;
cd(selpath)

%get all files that are of this type:
files = dir('Trial*.xlsx');
files = files(1:end);
%

i = 1;
for file = files'
    xlsx = readtable(file.name);
    xlsx = table2array(xlsx);
    
    a = num2str(xlsx(1,3));
    b = num2str(xlsx(1,4));
    c = num2str(xlsx(1,5));

    % Calculate time in milliseconds
    timeHrSecMs_imu(i,1) = cellstr(file.name);
    timeHrSecMS_imu(i,2) = cellstr(a);
    timeHrSecMS_imu(i,3) = cellstr(b);
    timeHrSecMS_imu(i,4) = cellstr(c);
    
    timeMS(i,1) = cellstr(file.name);
    
    d = (xlsx(1,3)*3600000 + xlsx(1,4)* 60000 + xlsx(1,5)* 1000);
    d = num2str(d);
    
    timeMS(i,2) = cellstr(d);
    i = i + 1;    
end
IMU_timeMS = timeMS;

clearvars -except IMU_timeMS STOPLIGHT_timeMS startTimeMS

