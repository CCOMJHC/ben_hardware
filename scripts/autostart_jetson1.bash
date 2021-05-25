#!/bin/bash

# called from cron @reboot using field's user crontab
# inspired by: https://answers.ros.org/question/140426/issues-launching-ros-on-startup/

DAY=$(date "+%Y-%m-%d")
NOW=$(date "+%Y-%m-%dT%H.%M.%S.%N")
LOGDIR="/home/field/project11/log/${DAY}"
mkdir -p "$LOGDIR"
LOG_FILE="${LOGDIR}/autostart_${NOW}.txt"

{

echo ""
echo "#############################################"
echo "Running autostart_jetson1.bash"
/bin/date
echo "#############################################" 
echo ""
echo "Logs:"

set -v


while ! ping -c 1 -W 1 jetson1c; do
    echo "Waiting for ping to jetson..."
    sleep 1
done

#source /opt/ros/melodic/setup.bash
source /home/field/ros_ws/install_isolated/setup.bash
source /home/field/project11/catkin_ws/devel/setup.bash

export ROS_WORKSPACE=/home/field/project11/catkin_ws
export ROS_IP=192.168.100.114
export ROS_MASTER_URI=http://192.168.100.112:11311

echo "running tmux..."

/usr/bin/tmux new -d -s project11 rosrun rosmon rosmon --name=rosmon_ben_jetson1 ben_hardware jetson1.launch

} >> "${LOG_FILE}" 2>&1
