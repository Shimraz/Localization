# Localization

Mobile robot localization is the problem of position estimation using sensors and a map of the environment. Simply stated, given a map of its environment, the goal of the robot is to determine its position relative to this map based on the perception of the environment and its movements. The map is normally expressed in the global coordinate frame and the robot in the robot coordinate frame. This reduces localization to a correspondence problem.
It therefore follows that localization is the process of establishing correspondence between the map coordinate frame and the robot’s local coordinate frame. Knowing the robot’s pose is sufficient to determine this transformation, assuming the pose is expressed in the same coordinate frame as the map. Unfortunately, pose sensors are noisy. Therefore, the pose has to be inferred from noisy measurements.
In this task, we will estimate the position of a differential drive robot using wheel encoders, gyroscope, accelerometer and GPS.
1. The given scene (Figure 1) contains a Pioneer robot driving in a closed loop. 
![image](https://user-images.githubusercontent.com/43060427/130220936-6a9a206a-5ce2-4794-986d-72f7228d743e.png)

Track and
plot the position of this robot in real-time in Matlab using wheel angles (emulating wheel
encoders) and robot kinematics. Matlab code for reading wheel angles is already
implemented. Note that the angle is in a range [-π, π]. Robot dimensions are found in
Figure 3.
Test: Track the robot for two complete loops while plotting the position in real-time
![image](https://user-images.githubusercontent.com/43060427/130221054-240ce127-d30b-438f-be88-fc39be2944c5.png)
![image](https://user-images.githubusercontent.com/43060427/130221070-e25136f7-4d30-4c11-b9fb-4fd681254a44.png)

2. The given scene contains a Pioneer robot driving in a closed loop. Track and plot the position of this robot in real-time in Matlab using simulated GPS. Matlab code for reading GPS position is already implemented.
Test: Track the robot for one complete loop while plotting the position in real-time.
4. The given scene contains a Pioneer robot driving in a closed loop. Track and plot the position of this robot in real-time in Matlab using simulated IMU sensor (gyroscope and accelerometer). Matlab code for reading gyroscope angular rates and translational accelerations is already implemented.
Test: Track the robot for one complete loop while plotting the position in real-time.
