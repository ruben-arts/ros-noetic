# Generated by vinca http://github.com/RoboStack/vinca.
# DO NOT EDIT!
# if [ -z "${CONDA_PREFIX}" ]; then
#     exit 0;
# fi

# Not sure if this is necessary on UNIX?
# export QT_PLUGIN_PATH=$CONDA_PREFIX\plugins

if [ "$CONDA_BUILD" = "1" -a "$target_platform" != "$build_platform" ]; then
    # ignore sourcing
    echo "Not activating ROS when cross-compiling";
else
    source $CONDA_PREFIX/setup.sh
fi

case "$OSTYPE" in
  darwin*)  export ROS_OS_OVERRIDE="robostack:osx";; 
  linux*)   export ROS_OS_OVERRIDE="robostack:linux";;
esac

export ROS_ETC_DIR=$CONDA_PREFIX/etc/ros
export AMENT_PREFIX_PATH=$CONDA_PREFIX

# Looks unnecessary for UNIX
# unset PYTHONHOME=
