# Me70_Final_Code: Impact of Distraction on Obstacle Avoidance Behavior

Team Lab 5B 
Alanna Levitt, Allison Moore, Ananya Ram, Gabriel De Brito, Joshua Fitzgerald, Michael Feltis, Olif Hordofa, Olivia Tomassetti

## Image Post Processing Code

Analysis and extrapolation of position, acceleration, jerk, and velocity data for each video trial using datapoints generated from FIJI motion tracking.

## Stoplight Code

### STOPLIGHT_getTimeMilliseconds.m
Runs inside trials folder to correct time for the stoplight signal.

# IMU Code
## Simple UDP- Send and Receive Modified
Full MATLAB VI for reading in Live IMU data and generating live graphs of position, velocity, and accelration. This data can be exported as a text file. 

## Adafruit_lsm6dsox_wifi-2021
Gyroscophic and motion tracking data collection code for the Arduino MKR 1010 WIFI.

## Jerk_Calculation.m

Script that scans the acceleration data in the range of the Stoplight time, selects the three biggest and 3 smallest points, and
outputs those values and their total average. 

## IMU_getTimeMilliseconds.m
Script that runs inside the Trials folder to look at each participant IMU start time and convert that value to milliseconds.

## Reaction Time Post Processing

### ReactionTimeAllison.m

Matlab code for post processing IMU data collected in "Simple UDP" to determine reaction time for the Particpant 2 trials. Generates graphs comparing reaction times across different trials and distraction conditions. 

### ReactionTimeOlif.m

Matlab code for post processing IMU data collected in "Simple UDP" to determine reaction time for the Particpant 1 trials. Generates graphs comparing reaction times across different trials and distraction conditions. 

### ReactionTimeAnanya.m

Matlab code for post processing IMU data collected in "Simple UDP" to determine reaction time for the Particpant 3 trials. Generates graphs comparing reaction times across different trials and distraction conditions. 


