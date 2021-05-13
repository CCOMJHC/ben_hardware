# !/bin/bash

# called from cron @reboot using field's user crontab
# inspired by: https://answers.ros.org/question/140426/issues-launching-ros-on-startup/

mkdir -p /home/field/project11/log/
LOG_FILE=/home/field/project11/log/autostart.txt

echo "" >> ${LOG_FILE}
echo "#############################################" >> ${LOG_FILE}
echo "Running autostart_jetson2.bash" >> ${LOG_FILE}
echo $(date) >> ${LOG_FILE}
echo "#############################################" >> ${LOG_FILE}
echo "" >> ${LOG_FILE}
echo "Logs:" >> ${LOG_FILE}

#wait for jetson to be pingable by self
while ! ping -c 1 -W 1 jetson2c; do
    echo "Waiting for ping to jetson..."
    sleep 1
done

echo "Wait 10 seconds before launching ROS..."
sleep 10

set -e

{
source /opt/ros/melodic/setup.bash
source /home/field/project11/catkin_ws/devel/setup.bash

export ROS_WORKSPACE=/home/field/project11/catkin_ws
export ROS_IP=192.168.100.113
export ROS_MASTER_URI=http://192.168.100.112:11311
} &>> ${LOG_FILE}

set -v

{
/home/field/project11/catkin_ws/src/ben_hardware/scripts/start_tmux_jetson2.sh
} &>> ${LOG_FILE}
