#!/bin/bash

LOG_FILE=/home/field/project11/log/start_tmux.txt

echo "" >> ${LOG_FILE}
echo "#############################################" >> ${LOG_FILE}
echo "Running start_tmux_jetson.bash" >> ${LOG_FILE}
echo $(date) >> ${LOG_FILE}
echo "#############################################" >> ${LOG_FILE}
echo "" >> ${LOG_FILE}
echo "Logs:" >> ${LOG_FILE}

set -e

{
source /home/field/ros_ws/install_isolated/setup.bash
source /home/field/project11/catkin_ws/devel/setup.bash

export ROS_WORKSPACE=/home/field/project11/catkin_ws
export ROS_IP=192.168.100.113
export ROS_MASTER_URI=http://192.168.100.112:11311

} &>> ${LOG_FILE}

set -v

{
tmux new -d -s project11 rosrun rosmon rosmon --name=rosmon_ben_jetson ben_hardware jetson.launch

} &>> ${LOG_FILE}
