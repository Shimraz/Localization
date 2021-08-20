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
    
    % IMU signals
    [gyro_err,gyro_signal]=vrep.simxReadStringStream(clientID,'gyro_data',vrep.simx_opmode_streaming);
    [accel_err,accel_signal]=vrep.simxReadStringStream(clientID,'accel_data',vrep.simx_opmode_streaming);
    
end
% call figure
%--------------------------------------------------------------------
environment(); %uncomment this line to plot in the map
%--------------------------------------------------------------------
line = line(nan, nan, 'color', 'red');

% Initialization of value
Ax(1) = 0;
Vx(1) = 0;
Dx(1) = 0;
t(1)  = 0;
PosX(1)  = 5;
PosY(1)  = 2;

Ar(1) = 0; 
Vr(1) = 0;
Pr(1) = 0;

theta(1) = pi;
i = 1;


 if (connected)   
    while (1) % CHANGE THIS LINE TO 'while loop'

        
        % Retrieves the simulation time of the last fetched command 
        [cmdTime] = vrep.simxGetLastCmdTime(clientID); % TIME IF YOU NEED IT
        
        % read gyroscope and accelerometer data
        [gyro_err,gyro_signal]=vrep.simxReadStringStream(clientID,'gyro_data',vrep.simx_opmode_buffer);
        [accel_err,accel_signal]=vrep.simxReadStringStream(clientID,'accel_data',vrep.simx_opmode_buffer);
        
        % Gyroscope
        if gyro_err == vrep.simx_return_ok
            [gyro_buffer]= vrep.simxUnpackFloats(gyro_signal);
            %disp(gyro_buffer(3:3:end))
            
            if isempty(gyro_buffer)
                continue
            end
            
        else
            continue;
        end
        
        
        % Accelerometer
        if accel_err == vrep.simx_return_ok
            [accel_buffer]= vrep.simxUnpackFloats(accel_signal);
            
            if isempty(accel_buffer)
                continue
            end
            
        else
            continue;
        end
        
        
            i = i + 1; % counter 
            t(i) = cmdTime; % real- time 

            dth = gyro_buffer (3) * (t(i) - t(i-1))/(1000); % change in theta 
            theta(i) = theta(i-1) + dth; % new theta  
            if (theta(i)< -pi)
                theta(i) = theta(i) + 2 * pi;
            elseif (theta(i)> pi)
                theta(i) = theta(i) - 2 * pi;
            end
            
            Ax(i) = accel_buffer(1); % reading accelerometer 
            Ar(i) = abs(Ax(i)) ;
            Vr(i) = 2.1 * (Ar(i)*(t(i) - t(i-1))/(1000)); % velocity calculation 
            
            Pr(i) = Vr(i);
            PosX(i) = PosX(i-1) + Pr(i) * cos(theta(i)); % position of x- coordinate 
            PosY(i) = PosY(i-1) + Pr(i) * sin(theta(i)); % position of y- coordinate 
            
        
        % plot in real-time
        x = get(line, 'xData');
        y = get(line, 'yData');

        %---------------------------------------------------------------------------------
        x = [x, PosX(i)];   % change n to any variable you want plotted
        y = [y, PosY(i)]; % change m to any variable you want plotted
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