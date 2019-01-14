# Return to bashrc if ROS is not installed
if ! [ -d /opt/ros ]; then
    return
fi

if [ -d /opt/ros/kinetic ]; then
    ROS_DISTRO=kinetic
else
    perr "No known ROS config installed ($(ls /opt/ros))"
    return
fi

# Import ROS configuration
. /opt/ros/$ROS_DISTRO/setup.bash
# Import configuration for default workspace at ~/catkin_ws
[ -f ~/catkin_ws/devel/setup.bash ] && source ~/catkin_ws/devel/setup.bash
