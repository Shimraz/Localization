% Feel free to add code anywhere you find necessary to solve the task.
% as a guide, we have provide recommendation where to add code
clear all, clc
%% DO NOT CHANGE ANYTHING HERE - Setting up the remote api
vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1); % just in case, close all opened connections
%clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,1);

% connection status
connected = false;

% robot parameters
d = 0.1950; % wheel radius
r = d/2; % wheel radius
T = 0.3310;% wheel track

if (clientID>-1)
    
    connected = true;
    disp('Connected to remote API server');
    
    % start simulation
    e = vrep.simxStartSimulation(clientID,vrep.simx_opmode_blocking);
    
    % GPS signal
    [gps_err,gps_signal]=vrep.simxReadStringStream(clientID,'gps_data',vrep.simx_opmode_streaming);
    
end
% call figure
%--------------------------------------------------------------------
environment(); %uncomment this line to plot in the map
%--------------------------------------------------------------------
line = line(nan, nan, 'color', 'red');

 if (connected)   
    while(1) % CHANGE THIS LINE TO 'while loop'

        % read GPS position
        [gps_err,gps_signal]=vrep.simxReadStringStream(clientID,'gps_data',vrep.simx_opmode_buffer);

        if gps_err == vrep.simx_return_ok
            [gps_buffer]= vrep.simxUnpackFloats(gps_signal);
             disp(gps_buffer) % sequence on (x, y, z,) positions
        end
        
        % Retrieves the simulation time of the last fetched command 
        [cmdTime] = vrep.simxGetLastCmdTime(clientID); % TIME IF YOU NEED IT

        % ADD CODE HERE
        A = gps_buffer(1:3:end); % to get x-coordinate from several array 
        B = gps_buffer(2:3:end); % to get y-coordinate from several array 
        
        X = mean(A);  % average of the x-coordinates 
        Y = mean(B);  % average of the y-coordinates 
        
        % plot in real-time
        x = get(line, 'xData');
        y = get(line, 'yData');
        
        %---------------------------------------------------------------------------------
        x = [x, X];   % change n to any variable you want plotted
        y = [y, Y]; % change m to any variable you want plotted
        %---------------------------------------------------------------------------------
        
        set(line, 'xData', x, 'yData', y);
        pause(0.1)
    end
    
    % stop simulation
    [~]=vrep.simxStopSimulation(clientID,vrep.simx_opmode_oneshot);
    pause(5);
    
    % Now close the connection to V-REP:    
    vrep.simxFinish(clientID);
else
    disp('Failed connecting to remote API server');
end
vrep.delete(); % call the destructor!