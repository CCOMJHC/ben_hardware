# !/bin/bash

# called from cron @reboot using field's user crontab
# inspired by: https://answers.ros.org/question/140426/issues-launching-ros-on-startup/

DAY=$(date "+%Y-%m-%d")
NOW=$(date "+%Y-%m-%dT%H.%M.%S.%N")
LOGDIR="/home/field/project11/log/${DAY}"
mkdir -p ${LOGDIR}
LOG_FILE= "${LOGDIR}/autostart_${NOW}.txt"

echo "" >> ${LOG_FILE}
echo "#############################################" >> ${LOG_FILE}
echo "Running autostart_jetson1.bash" >> ${LOG_FILE}
echo $(date) >> ${LOG_FILE}
echo "#############################################" >> ${LOG_FILE}
echo "" >> ${LOG_FILE}
echo "Logs:" >> ${LOG_FILE}

#wait for jetson to be pingable by self
while ! ping -c 1 -W 1 jetson1c; do
    echo "Waiting for ping to jetson..."
    sleep 1
done

#echo "Wait 10 seconds before launching ROS..."
#sleep 10

set -e

{
#source /opt/ros/melodic/setup.bash
source /home/field/ros_ws/install_isolated/setup.bash
source /home/field/project11/catkin_ws/devel/setup.bash

export ROS_WORKSPACE=/home/field/project11/catkin_ws
export ROS_IP=192.168.100.114
export ROS_MASTER_URI=http://192.168.100.112:11311
} &>> ${LOG_FILE}

set -v

{
  tmux new -d -s project11 rosrun rosmon rosmon --name=rosmon_ben_jetson1 ben_hardware jetson1.launch
} &>> ${LOG_FILE}
