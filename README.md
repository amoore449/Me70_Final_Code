# Me70_Final_Code

## Image Post Processing Code

Analysis and extrapolation of position, acceleration, jerk, and velocity data for each video trial using datapoints generated from FIJI motion tracking

## Stoplight Code

### STOPLIGHT_getTimeMilliseconds.m
Runs inside trials folder to correct time for the stoplight signal.

# IMU Code
## Adafruit_lsm6dsox_wifi-2021
Gyroscophic and motion tracking data collection code for the Arduino MKR 1010 WIFI.

## Jerk_Calculation.m

Script that scans the acceleration data in the range of the Stoplight time, selects the three biggest and 3 smallest points, and
outputs those values and their total average. 

## IMU_getTimeMilliseconds.m
Script that runs inside the Trials folder to look at each participant IMU start time and convert that value to milliseconds.


