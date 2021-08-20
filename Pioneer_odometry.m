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
    
    % get object handles
    [~,leftMotor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_leftMotor',vrep.simx_opmode_blocking);
    [~,rightMotor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_rightMotor',vrep.simx_opmode_blocking);
    
    % initialize motor position reading (encoder)
    [~, rotLM]=vrep.simxGetJointPosition(clientID, leftMotor, vrep.simx_opmode_streaming);
    [~, rotRM]=vrep.simxGetJointPosition(clientID, rightMotor, vrep.simx_opmode_streaming);
  
    
end
% call figure
%--------------------------------------------------------------------
environment(); %uncomment this line to plot in the map
%--------------------------------------------------------------------
line = line(nan, nan, 'color', 'red');
 
% Initial Position and orientation of the robot
theta(1) = pi; 
X(1) = 5 + r*pi;
Y(1) = 2;

% Counter
i = 1;

 if (connected)   
    while(1) % CHANGE THIS LINE TO 'while loop'
        i = i +1;
         % get motor angular position (encoder emulator)
        [~, rotLM]=vrep.simxGetJointPosition(clientID, leftMotor, vrep.simx_opmode_buffer );
        [~, rotRM]=vrep.simxGetJointPosition(clientID, rightMotor, vrep.simx_opmode_buffer );
        
        % Retrieves the simulation time of the last fetched command 
        [cmdTime] = vrep.simxGetLastCmdTime(clientID); % TIME IF YOU NEED IT

        % ADD CODE HERE

        rotLM = rotLM + pi; % To make encoder value range from 0 t0 2pi for leftwheel
        rotRM = rotRM + pi; % To make encoder value range from 0 t0 2pi for rightwheel
        
        
        RedL(i) = rotLM;
        RedR(i) = rotRM;
        
        % To calcualte the orientation of the robot 
        if (RedL(i) < RedL(i-1))
            L(i) = RedL(i) - RedL(i-1)  + 2*pi;
        else
            L(i) = RedL(i) - RedL(i-1);
        end
        
        if (RedR(i) < RedR(i-1))
            R(i) = RedR(i) - RedR(i-1) + 2*pi;
        else
            R(i) = RedR(i) - RedR(i-1);
        end        
         
         dl = (r * (L(i))); % distance from left wheel 
         dr = (r * (R(i))); % distance from right wheel 
         dtheta =  (dr - dl)/T; % calculate the change in angle (dtheta)
         
         theta(i) = theta(i-1) + dtheta; % new orientation of robot 
         X(i) = X(i-1) + 0.5 * ((dl + dr)) * (cos( theta(i-1) )); % new x- coordinate 
         Y(i) = Y(i-1) + 0.5 * ((dl + dr)) * (sin( theta(i-1) )); % new y- coordinate
                

         % plot in real-time
         x = get(line, 'xData');
         y = get(line, 'yData');
        
        %---------------------------------------------------------------------------------
           x = [x, X(i)];      % change n to any variable you want plotted
           y = [y, Y(i)];      % change m to any variable you want plotted
         %---------------------------------------------------------------------------------
         
          set(line, 'xData', x, 'yData', y);
         pause(0.1)
         disp (X(i))
         disp (Y(i))
         
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