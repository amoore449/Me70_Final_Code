% STOPLIGHT getTimeMilliseconds

% This is a script that runs inside the Trials folder.
% It gets the MATLAB-generated start times and subtracts the correction
% factor (108 seconds between computers)

xlsx = readtable('StopSignTimes.xlsx');
xlsx2 = table2array(xlsx(:,2:5));
trialParticipants = table2cell(xlsx(:,1));

startTimeMS = xlsx2(:,2)*3600000 + xlsx2(:,3)*60000 + xlsx2(:,4)*1000;

%We realized that we need to offset the total time by 108 seconds.

%timeOffset = 88 * 1000; %ms off
timeOffset = 0;
startTimeMS = startTimeMS - timeOffset;

%Now figure out the exact time that the stoplight went off!
STOPLIGHT_timeMS = startTimeMS + 1000*(xlsx2(:,1));

%Append the name of the person...
STOPLIGHT_timeMS = [(trialParticipants), num2cell(STOPLIGHT_timeMS)];


clearvars -except IMU_timeMS STOPLIGHT_timeMS startTimeMS

%% Appendix (old code)

%trialParticipants = {'Olif','Olif','Olif','Olif','Olif','Olif','Olif','Olif','Olif', '', 'Ananya', 'Ananya','Ananya','Ananya','Ananya','Ananya','Ananya','Ananya','Ananya', '','', 'Allison','Allison','Allison','Allison','Allison','Allison','Allison','Allison','Allison'};
%trialParticipants = trialParticipants';
%writeThis = [timeMS,trialParticipants];

%xlswrite('Output_STOPLIGHT_getTimeMilliseconds', STOPLIGHT_timeMS);
%disp(trialParticipants)