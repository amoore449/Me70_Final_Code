clear
close all

%Lateral Position is in column 4 (given in pixels), time step is given in  is in column
%8, and is in frames (at 30 FPS for this run)

%This is for Allison's Data. For the other two versions, swap in Ananya and
%Olif's data, cross your fingers, and run it!

data01A = xlsread('Trial01AAllison.csv');
data02A = xlsread('Trial02AAllison.csv');
data03A = xlsread('Trial03AAllison.csv');

data01B = xlsread('Trial01BAllison.csv');
data02B = xlsread('Trial02BAllison.csv');
data03B = xlsread('Trial03BAllison.csv');

data01C = xlsread('Trial01CAllison.csv');
data02C = xlsread('Trial02CAllison.csv');
data03C = xlsread('Trial03CAllison.csv');



%Limit end of data to cut out camera moving
pos_x_pixels01A = -1*data01A(:,4);%Position Data, given in pixel position, must be normalized. Times -1 because of orientation
pos_x_pixels02A = -1*data02A(:,4);
pos_x_pixels03A = -1*data03A(:,4);

pos_x_pixels01B = -1*data01B(:,4);
pos_x_pixels02B = -1*data02B(:,4);
pos_x_pixels03B = -1*data03B(:,4);

pos_x_pixels01C = -1*data01C(:,4);
pos_x_pixels02C = -1*data02C(:,4);
pos_x_pixels03C = -1*data03C(:,4);

%Y data just to confirm shape from imagej, not actually useful.
pos_y_pixels = data01A(:,5); %Y position data is a mix of true z and y positions, and is not valuable outside of confirming the same visual pattern generated in Imagej

%Frame number, for extracting time
frame_num01A = data01A(:,8); %Frame number, at 30 FPS, convert into time.
frame_num02A = data02A(:,8);
frame_num03A = data03A(:,8);

frame_num01B = data01B(:,8);
frame_num02B = data02B(:,8);
frame_num03B = data03B(:,8);

frame_num01C = data01C(:,8);
frame_num02C = data02C(:,8);
frame_num03C = data03C(:,8);

time01A = frame_num01A/30; %time, in seconds (framerate of 30 FPS)
time02A = frame_num02A/30;
time03A = frame_num03A/30;

time01B = frame_num01B/30;
time02B = frame_num02B/30;
time03B = frame_num03B/30;

time01C = frame_num01C/30;
time02C = frame_num02C/30;
time03C = frame_num03C/30;

%Normalizes the x-position data to exist between 0 and 1 for the total
%range traversed.
x_norm01A = (pos_x_pixels01A-min(pos_x_pixels01A))/(max(pos_x_pixels01A)-min(pos_x_pixels01A));
x_norm02A = (pos_x_pixels02A-min(pos_x_pixels02A))/(max(pos_x_pixels02A)-min(pos_x_pixels02A));
x_norm03A = (pos_x_pixels03A-min(pos_x_pixels03A))/(max(pos_x_pixels03A)-min(pos_x_pixels03A));

x_norm01B = (pos_x_pixels01B-min(pos_x_pixels01B))/(max(pos_x_pixels01B)-min(pos_x_pixels01B));
x_norm02B = (pos_x_pixels02B-min(pos_x_pixels02B))/(max(pos_x_pixels02B)-min(pos_x_pixels02B));
x_norm03B = (pos_x_pixels03B-min(pos_x_pixels03B))/(max(pos_x_pixels03B)-min(pos_x_pixels03B));

x_norm01C = (pos_x_pixels01C-min(pos_x_pixels01C))/(max(pos_x_pixels01C)-min(pos_x_pixels01C));
x_norm02C = (pos_x_pixels02C-min(pos_x_pixels02C))/(max(pos_x_pixels02C)-min(pos_x_pixels02C));
x_norm03C = (pos_x_pixels03C-min(pos_x_pixels03C))/(max(pos_x_pixels03C)-min(pos_x_pixels03C));



y_norm = (pos_y_pixels-min(pos_y_pixels))/(max(pos_y_pixels)-min(pos_y_pixels)); %Just for testing

xpos01A = x_norm01A*5.05; %Position in meters, 5.05 m is the length of laterial total dimension.
xpos02A = x_norm02A*5.05;
xpos03A = x_norm03A*5.05;

xpos01B = x_norm01B*5.05;
xpos02B = x_norm02B*5.05;
xpos03B = x_norm03B*5.05;

xpos01C = x_norm01C*5.05;
xpos02C = x_norm02C*5.05;
xpos03C = x_norm03C*5.05;


ypos = -y_norm*0.25; %Again, just for confirming the shape of the x-y map from imagej.

%Shape confirmation, check
%figure(1)
%plot(xpos01A,ypos)
%title('Please Ignore Me!')

%Velocities

figure(2)
hold on
velx01A=diff(xpos01A)./diff(time01A); %Discrete derivative
velx02A=diff(xpos02A)./diff(time02A);
velx03A=diff(xpos03A)./diff(time03A);

velx01B=diff(xpos01B)./diff(time01B);
velx02B=diff(xpos02B)./diff(time02B);
velx03B=diff(xpos03B)./diff(time03B);

velx01C=diff(xpos01C)./diff(time01C);
velx02C=diff(xpos02C)./diff(time02C);
velx03C=diff(xpos03C)./diff(time03C);

plot(time01A(2:end),velx01A,'-') %Note that you lose the first entry through the derivative, so you must omit the first time step.
plot(time02A(2:end),velx02A,'-')
plot(time03A(2:end),velx03A,'-')
plot(time01B(2:end),velx01B,'-')
plot(time02B(2:end),velx02B,'-')
plot(time03B(2:end),velx03B,'-')
plot(time01C(2:end),velx01C,'-')
plot(time02C(2:end),velx02C,'-')
plot(time03C(2:end),velx03C,'-')
title('Total Velocity Signals, Unfiltered')
ylabel('Velocity (m/s)')
xlabel('Time (s)') 
legend('Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01B(Distracted)','Trial 02B(Distracted)','Trial 03B(Distracted)','Trial 01C(Distracted)','Trial 02C(Distracted)','Trial 03C(Distracted)')

% %Acceleration

figure(3)
hold on
accx01A=diff(velx01A)./diff(time01A(2:end));
accx02A=diff(velx02A)./diff(time02A(2:end));
accx03A=diff(velx03A)./diff(time03A(2:end));

accx01B=diff(velx01B)./diff(time01B(2:end));
accx02B=diff(velx02B)./diff(time02B(2:end));
accx03B=diff(velx03B)./diff(time03B(2:end));

accx01C=diff(velx01C)./diff(time01C(2:end));
accx02C=diff(velx02C)./diff(time02C(2:end));
accx03C=diff(velx03C)./diff(time03C(2:end));


plot(time01A(3:end),accx01A)%end-2 for double differentiation.
plot(time02A(3:end),accx02A)
plot(time03A(3:end),accx03A)
plot(time01B(3:end),accx01B)
plot(time02B(3:end),accx02B)
plot(time03B(3:end),accx03B)
plot(time01C(3:end),accx01C)
plot(time02C(3:end),accx02C)
plot(time03C(3:end),accx03C)
title('Total Acceleration Signals, Unadjusted')
ylabel('Acceleration (m/s^{2})')
xlabel('Time (s)')
legend('Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01B(Distracted)','Trial 02B(Distracted)','Trial 03B(Distracted)','Trial 01C(Distracted)','Trial 02C(Distracted)','Trial 03C(Distracted)')



%Jerk (what did you call me?)

figure(4)
hold on
jerkx01A=diff(accx01A)./diff(time01A(3:end));
jerkx02A=diff(accx02A)./diff(time02A(3:end));
jerkx03A=diff(accx03A)./diff(time03A(3:end));

jerkx01B=diff(accx01B)./diff(time01B(3:end));
jerkx02B=diff(accx02B)./diff(time02B(3:end));
jerkx03B=diff(accx03B)./diff(time03B(3:end));

jerkx01C=diff(accx01C)./diff(time01C(3:end));
jerkx02C=diff(accx02C)./diff(time02C(3:end));
jerkx03C=diff(accx03C)./diff(time03C(3:end));


plot(time01A(4:end-50),jerkx01A(1:end-50))
plot(time02A(4:end-50),jerkx02A(1:end-50))
plot(time03A(4:end-50),jerkx03A(1:end-50))
plot(time01B(4:end-50),jerkx01B(1:end-50))
plot(time02B(4:end-50),jerkx02B(1:end-50))
plot(time03B(4:end-50),jerkx03B(1:end-50))
plot(time01C(4:end-50),jerkx01C(1:end-50))
plot(time02C(4:end-50),jerkx02C(1:end-50))
plot(time03C(4:end-50),jerkx03C(1:end-50))
title('Total Jerk Signals, Unadjusted')
ylabel('Jerk (m/s^{3})')
xlabel('Time (s)')
legend('Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01B(Distracted)','Trial 02B(Distracted)','Trial 03B(Distracted)','Trial 01C(Distracted)','Trial 02C(Distracted)','Trial 03C(Distracted)')


%Moving Average Velocity
figure(5)
hold on

velxx01A = movmean(velx01A,7); %7 point moving average
velxx02A = movmean(velx02A,7);
velxx03A = movmean(velx03A,7);

velxx01B = movmean(velx01B,7);
velxx02B = movmean(velx02B,7);
velxx03B = movmean(velx03B,7);

velxx01C = movmean(velx01C,7);
velxx02C = movmean(velx02C,7);
velxx03C = movmean(velx03C,7);


plot(time01A(2:end),velxx01A)
plot(time02A(2:end),velxx02A)
plot(time03A(2:end),velxx03A)
plot(time01B(2:end),velxx01B)
plot(time02B(2:end),velxx02B)
plot(time03B(2:end),velxx03B)
plot(time01C(2:end),velxx01C)
plot(time02C(2:end),velxx02C)
plot(time03C(2:end),velxx03C)
title('Unaligned Velocity Signals w/ 7 Point Moving Average')
ylabel('Velocity (m/s)')
xlabel('Time (s)')
legend('Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01B(Distracted)','Trial 02B(Distracted)','Trial 03B(Distracted)','Trial 01C(Distracted)','Trial 02C(Distracted)','Trial 03C(Distracted)')

%Moving Acceleration Average
figure(6)
hold on

accxx01A=diff(velxx01A)./diff(time01A(2:end)); %Discrete derivative of filtered data
accxx02A=diff(velxx02A)./diff(time02A(2:end));
accxx03A=diff(velxx03A)./diff(time03A(2:end));

accxx01B=diff(velxx01B)./diff(time01B(2:end));
accxx02B=diff(velxx02B)./diff(time02B(2:end));
accxx03B=diff(velxx03B)./diff(time03B(2:end));

accxx01C=diff(velxx01C)./diff(time01C(2:end));
accxx02C=diff(velxx02C)./diff(time02C(2:end));
accxx03C=diff(velxx03C)./diff(time03C(2:end));

accxxx01A=movmean(accxx01A,7); %Secondary filter
accxxx02A=movmean(accxx02A,7);
accxxx03A=movmean(accxx03A,7);

accxxx01B=movmean(accxx01B,7);
accxxx02B=movmean(accxx02B,7);
accxxx03B=movmean(accxx03B,7);

accxxx01C=movmean(accxx01C,7);
accxxx02C=movmean(accxx02C,7);
accxxx03C=movmean(accxx03C,7);

plot(time01A(3:end),accxxx01A)
plot(time02A(3:end),accxxx02A)
plot(time03A(3:end),accxxx03A)
plot(time01B(3:end),accxxx01B)
plot(time02B(3:end),accxxx02B)
plot(time03B(3:end),accxxx03B)
plot(time01C(3:end),accxxx01C)
plot(time02C(3:end),accxxx02C)
plot(time03C(3:end),accxxx03C)
title('X Acceleration Signal')
ylabel('Acceleration (m/s^{2})')
xlabel('Time (s)')
legend('Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01B(Distracted)','Trial 02B(Distracted)','Trial 03B(Distracted)','Trial 01C(Distracted)','Trial 02C(Distracted)','Trial 03C(Distracted)')

figure(7)
hold on
title('Filtered Power Signal')
powerxx01A = velxx01A(2:end).*accxxx01A;
powerxx02A = velxx02A(2:end).*accxxx02A;
powerxx03A = velxx03A(2:end).*accxxx03A;

powerxx01B = velxx01B(2:end).*accxxx01B;
powerxx02B = velxx02B(2:end).*accxxx02B;
powerxx03B = velxx03B(2:end).*accxxx03B;

powerxx01C = velxx01C(2:end).*accxxx01C;
powerxx02C = velxx02C(2:end).*accxxx02C;
powerxx03C = velxx03C(2:end).*accxxx03C;

plot(time01A(3:end),powerxx01A)
plot(time02A(3:end),powerxx02A)
plot(time03A(3:end),powerxx03A)
plot(time01B(3:end),powerxx01B)
plot(time02B(3:end),powerxx02B)
plot(time03B(3:end),powerxx03B)
plot(time01C(3:end),powerxx01C)
plot(time02C(3:end),powerxx02C)
plot(time03C(3:end),powerxx03C)
legend('Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01B(Distracted)','Trial 02B(Distracted)','Trial 03B(Distracted)','Trial 01C(Distracted)','Trial 02C(Distracted)','Trial 03C(Distracted)')
ylabel('Power/Unit Mass (W/kg)')
xlabel('time (s)')
title('Moving-Average Filtered Power Signal')


%Align data based on deceleration event. (ranges may need to vary based on
%trial*** Find range of data such that the obvious deceleration peak is
%encompassed (and hopefully the largest negative value)

acc_x_01A_intermediate = accxxx01A(75:200); %Weird value is to capture the deceleration peak, which for this trial is not the lowest peak
acc_x_02A_intermediate = accxxx02A(75:200);
acc_x_03A_intermediate = accxxx03A(75:200);

acc_x_01B_intermediate = accxxx01B(75:200);
acc_x_02B_intermediate = accxxx02B(75:200);
acc_x_03B_intermediate = accxxx03B(75:200);

acc_x_01C_intermediate = accxxx01C(75:200); 
acc_x_02C_intermediate = accxxx02C(75:200);
acc_x_03C_intermediate = accxxx03C(75:200);


%data centered on peak of deceleration event for comparison.
acc_x_01A = accxxx01A((find(accxxx01A==min(acc_x_01A_intermediate))-100):(find(accxxx01A==min(acc_x_01A_intermediate))+100));
acc_x_02A = accxxx02A(find(accxxx02A==min(acc_x_02A_intermediate))-100:find(accxxx02A==min(acc_x_02A_intermediate))+100);
acc_x_03A = accxxx03A(find(accxxx03A==min(acc_x_03A_intermediate))-100:find(accxxx03A==min(acc_x_03A_intermediate))+100);

acc_x_01B = accxxx01B(find(accxxx01B==min(acc_x_01B_intermediate))-100:find(accxxx01B==min(acc_x_01B_intermediate))+100);
acc_x_02B = accxxx02B(find(accxxx02B==min(acc_x_02B_intermediate))-100:find(accxxx02B==min(acc_x_02B_intermediate))+100);
acc_x_03B = accxxx03B(find(accxxx03B==min(acc_x_03B_intermediate))-100:find(accxxx03B==min(acc_x_03B_intermediate))+100);

acc_x_01C = accxxx01C(find(accxxx01C==min(acc_x_01C_intermediate))-100:find(accxxx01C==min(acc_x_01C_intermediate))+100);
acc_x_02C = accxxx02C(find(accxxx02C==min(acc_x_02C_intermediate))-100:find(accxxx02C==min(acc_x_02C_intermediate))+100);
acc_x_03C = accxxx03C(find(accxxx03C==min(acc_x_03C_intermediate))-100:find(accxxx03C==min(acc_x_03C_intermediate))+100);


time_new = time01A((find(accxxx01A==min(acc_x_01A_intermediate))-100):(find(accxxx01A==min(acc_x_01A_intermediate))+100));
time = time_new-time_new(find(acc_x_01A==min(acc_x_01A_intermediate)));

figure(10)
hold on
plot(time,acc_x_01A)
plot(time,acc_x_02A)
plot(time,acc_x_03A)
plot(time,acc_x_01B)
plot(time,acc_x_02B)
plot(time,acc_x_03B)
plot(time,acc_x_01C)
plot(time,acc_x_02C)
plot(time,acc_x_03C)
xline(-.4,'r--')
xline(1,'g--')
yline(0,'--')
title('Acceleration Signals Centered on Deceleration Event')
xlabel('Time Before & After Peak Stopping Deceleration (s)')
ylabel('Acceleration (m/s^{2})')
legend('Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01B(Distracted)','Trial 02B(Distracted)','Trial 03B(Distracted)','Trial 01C(Distracted)','Trial 02C(Distracted)','Trial 03C(Distracted)','Steady Motion Stops (Break Initiates)','Subject Stationary','x-axis')

%Data of just the breaking events. We could run statistical tests on this.

totest01A = accxxx01A(find(accxxx01A==min(acc_x_01A_intermediate))-50:find(accxxx01A==min(acc_x_01A_intermediate))+50);
totest02A = accxxx02A(find(accxxx02A==min(acc_x_02A_intermediate))-50:find(accxxx02A==min(acc_x_02A_intermediate))+50);
totest03A = accxxx03A(find(accxxx03A==min(acc_x_03A_intermediate))-50:find(accxxx03A==min(acc_x_03A_intermediate))+50);

totest01B = accxxx01B(find(accxxx01B==min(acc_x_01B_intermediate))-50:find(accxxx01B==min(acc_x_01B_intermediate))+50);
totest02B = accxxx02B(find(accxxx02B==min(acc_x_02B_intermediate))-50:find(accxxx02B==min(acc_x_02B_intermediate))+50);
totest03B = accxxx03B(find(accxxx03B==min(acc_x_03B_intermediate))-50:find(accxxx03B==min(acc_x_03B_intermediate))+50);

totest01C = accxxx01C(find(accxxx01C==min(acc_x_01C_intermediate))-50:find(accxxx01C==min(acc_x_01C_intermediate))+50);
totest02C = accxxx02C(find(accxxx02C==min(acc_x_02C_intermediate))-50:find(accxxx02C==min(acc_x_02C_intermediate))+50);
totest03C = accxxx03C(find(accxxx03C==min(acc_x_03C_intermediate))-50:find(accxxx03C==min(acc_x_03C_intermediate))+50);

time_new = time01A(find(acc_x_01A==min(acc_x_01A_intermediate))-50:find(acc_x_01A==min(acc_x_01A_intermediate))+50);
test_time = time_new-time_new(find(totest01A==min(totest01A)));

figure(11)
hold on
plot(test_time,totest01A)
plot(test_time,totest02A)
plot(test_time,totest03A)
plot(test_time,totest01B)
plot(test_time,totest02B)
plot(test_time,totest03B)
plot(test_time,totest01C)
plot(test_time,totest02C)
plot(test_time,totest03C)
title('Acceleration Signals Centered on Deceleration Event')
xlabel('Time Before & After Peak Stopping Deceleration (s)')
ylabel('Acceleration (m/s^{2})')
legend('Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01B(Distracted)','Trial 02B(Distracted)','Trial 03B(Distracted)','Trial 01C(Distracted)','Trial 02C(Distracted)','Trial 03C(Distracted)')

figure(12)

hold on
plot(time,acc_x_01A,'b')
plot(time,acc_x_02A,'b')
plot(time,acc_x_03A,'b')
plot(time,acc_x_01B,'r')
plot(time,acc_x_02B,'r')
plot(time,acc_x_03B,'r')
plot(time,acc_x_01C,'g')
plot(time,acc_x_02C,'g')
plot(time,acc_x_03C,'g')
xline(-.4,'r--')
xline(1,'g--')
yline(0,'--')
title('Acceleration Signals Centered on Deceleration Event')
xlabel('Time Before & After Peak Stopping Deceleration (s)')
ylabel('Acceleration (m/s^{2})')
legend('Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01B(Distracted)','Trial 02B(Distracted)','Trial 03B(Distracted)','Trial 01C(Distracted)','Trial 02C(Distracted)','Trial 03C(Distracted)','Steady Motion Stops (Break Initiates)','Subject Stationary','x-axis')

% figure(13)
% A =([totest01A,totest02A,totest03A,totest01B,totest02B,totest03B,totest01C,totest02C,totest03C]);
% 
% [p tbl stats] = anova1(A)
% 
% [pA tblA statsA] = anova1([totest01A,totest02A,totest03A])
% 
% [pB tblB statsB] = anova1([totest01B,totest02B,totest03B])
% 
% [pC tblC statsC] = anova1([totest01C,totest02C,totest03C])
% 
% [paa] = anova1([totest01A,totest01C])

%Moving Average Velocity
figure(13)
hold on

velxx01A = movmean(velx01A,7); %7 point moving average
velxx02A = movmean(velx02A,7);
velxx03A = movmean(velx03A,7);

velxx01B = movmean(velx01B,7);
velxx02B = movmean(velx02B,7);
velxx03B = movmean(velx03B,7);

velxx01C = movmean(velx01C,7);
velxx02C = movmean(velx02C,7);
velxx03C = movmean(velx03C,7);


plot(time01A(2:end),velxx01A,'r')
plot(time02A(2:end),velxx02A,'r')
plot(time03A(2:end),velxx03A,'r')
plot(time01B(2:end),velxx01B,'b')
plot(time02B(2:end),velxx02B,'b')
plot(time03B(2:end),velxx03B,'b')
plot(time01C(2:end),velxx01C,'g')
plot(time02C(2:end),velxx02C,'g')
plot(time03C(2:end),velxx03C,'g')
legend('Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01A(Undistracted)','Trial 01B(Distracted)','Trial 02B(Distracted)','Trial 03B(Distracted)','Trial 01C(Distracted)','Trial 02C(Distracted)','Trial 03C(Distracted)')


figure(14)

plot(time01A(3:end),accxxx01A)