# Return to bashrc if ROS is not installed
if ! [ -d /opt/ros ]; then
    return
fi

if [ -d /opt/ros/kinetic ]; then
    ROS_DISTRO=kinetic
elif [ -d /opt/ros/noetic ]; then
    ROS_DISTRO=noetic
else
    perr "No known ROS config installed ($(ls /opt/ros))"
    return
fi

function cb {
    # Subshell so we don't actually cd
    (
        cd -P ~/catkin_ws
        catkin build "$@"
        # Return the exit code of catkin build so we can do things like
        # `cb && roslaunch ...`
        local ret=$?
        rm -f compile_commands.json
        cat build/**/compile_commands.json > compile_commands.json && \
            sed -i -e ':a;N;$!ba;s/\]\[/,/g' compile_commands.json
        exit $ret
    )
}

function ros_setup {
    # Import ROS configuration
    . /opt/ros/$ROS_DISTRO/setup.bash
    # Import configuration for default workspace at ~/catkin_ws
    [ -f ~/catkin_ws/devel/setup.bash ] && source ~/catkin_ws/devel/setup.bash
    # Start roscore
    cmd_exists tmux &&
        { ls ~/.ros/roscore-*.pid &>/dev/null &&
            kill -0 $(cat ~/.ros/roscore-*.pid) &>/dev/null; } ||
        { tmux new-session -d -s "roscore" roscore && echo "roscore started"; }

    # Check how much space the logs are using up
    MIN_LOG_SPACE_FOR_WARN=100M
    log_space=$(rosclean check)
    set -- $log_space
    min_log_space=$(echo -e "$1\n$MIN_LOG_SPACE_FOR_WARN" | sort -h | head -1)
    if [ "$min_log_space" = "$MIN_LOG_SPACE_FOR_WARN" ]; then
        echo $'\e[1;33m'"$log_space"$'\nTo clean, run rosclean purge.\e[0m\n'
    fi
}

if [ -f ~/.auto_ros ]; then
    ros_setup
fi
