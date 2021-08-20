# Localization

Mobile robot localization is the problem of position estimation using sensors and a map of the environment. Simply stated, given a map of its environment, the goal of the robot is to determine its position relative to this map based on the perception of the environment and its movements. The map is normally expressed in the global coordinate frame and the robot in the robot coordinate frame. This reduces localization to a correspondence problem.
It therefore follows that localization is the process of establishing correspondence between the map coordinate frame and the robot’s local coordinate frame. Knowing the robot’s pose is sufficient to determine this transformation, assuming the pose is expressed in the same coordinate frame as the map. Unfortunately, pose sensors are noisy. Therefore, the pose has to be inferred from noisy measurements.
In this task, we will estimate the position of a differential drive robot using wheel encoders, gyroscope, accelerometer and GPS.
The given scene (Figure 1) contains a Pioneer robot driving in a closed loop. Track and
plot the position of this robot in real-time in Matlab using wheel angles (emulating wheel
encoders) and robot kinematics. Matlab code for reading wheel angles is already
implemented. Note that the angle is in a range [-π, π]. Robot dimensions are found in
Figure 3.
