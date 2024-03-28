#!/bin/bash

# called from cron @reboot using field's user crontab
# inspired by: https://answers.ros.org/question/140426/issues-launching-ros-on-startup/

DAY=$(date "+%Y-%m-%d")
NOW=$(date "+%Y-%m-%dT%H.%M.%S.%N")
LOGDIR="/home/field/project11/logs"
mkdir -p "$LOGDIR"
LOG_FILE="${LOGDIR}/autostart_${NOW}.txt"

{

echo ""
echo "#############################################"
echo "Running autostart_jetson2.bash"
/bin/date
echo "#############################################" 
echo ""
echo "Logs:"

source /opt/ros/noetic/setup.bash
source /home/field/project11/catkin_ws/devel/setup.bash

set -v

while ! ping -c 1 -W 1 jetson2; do
    echo "Waiting for ping to jetson..."
    sleep 1
done

export ROS_WORKSPACE=/home/field/project11/catkin_ws
export ROS_IP=192.168.10.114
export ROS_MASTER_URI=http://192.168.10.112:11311

echo "running tmux..."

/usr/bin/tmux new -d -s project11 rosrun rosmon rosmon --name=rosmon_ben_jetson2 ben_hardware jetson2.launch jetsonStats:=false

} >> "${LOG_FILE}" 2>&1

