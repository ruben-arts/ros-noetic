# Generated by vinca http://github.com/RoboStack/vinca.
# DO NOT EDIT!

CATKIN_BUILD_BINARY_PACKAGE="ON"

if [ "${PKG_NAME}" == "ros-noetic-catkin" ]; then
    # create catkin cookie to make it is a catkin workspace
    touch $PREFIX/.catkin
    # keep the workspace activation scripts (e.g., local_setup.bat)
    CATKIN_BUILD_BINARY_PACKAGE="OFF"
fi

rm -rf build
mkdir build
cd build

# necessary for correctly linking SIP files (from python_qt_bindings)
export LINK=$CXX

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  PYTHON_EXECUTABLE=$PREFIX/bin/python
  PKG_CONFIG_EXECUTABLE=$PREFIX/bin/pkg-config
else
  PYTHON_EXECUTABLE=$BUILD_PREFIX/bin/python
  PKG_CONFIG_EXECUTABLE=$BUILD_PREFIX/bin/pkg-config
fi

echo "USING PYTHON_EXECUTABLE=${PYTHON_EXECUTABLE}"
echo "USING PKG_CONFIG_EXECUTABLE=${PKG_CONFIG_EXECUTABLE}"

export ROS_PYTHON_VERSION=`$PYTHON_EXECUTABLE -c "import sys; print('%i.%i' % (sys.version_info[0:2]))"`
echo "Using Python $ROS_PYTHON_VERSION"

# see https://github.com/conda-forge/cross-python-feedstock/issues/24
if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  find $PREFIX/lib/cmake -type f -exec sed -i "s~\${_IMPORT_PREFIX}/lib/python$ROS_PYTHON_VERSION/site-packages~$BUILD_PREFIX/lib/python$ROS_PYTHON_VERSION/site-packages~g" {} +
fi

# NOTE: there might be undefined references occurring
# in the Boost.system library, depending on the C++ versions
# used to compile Boost. We can avoid them by forcing the use of
# the header-only version of the library.
export CXXFLAGS="$CXXFLAGS -DBOOST_ERROR_CODE_HEADER_ONLY"

if [[ $target_platform =~ linux.* ]]; then
    export CXXFLAGS="$CXXFLAGS -D__STDC_FORMAT_MACROS=1";
    # I am too scared to turn this on for now ...
    # export LDFLAGS="$LDFLAGS -lrt";
fi

export SKIP_TESTING=ON

cmake ${CMAKE_ARGS} .. -DCMAKE_INSTALL_PREFIX=$PREFIX \
         -DCMAKE_PREFIX_PATH=$PREFIX \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_INSTALL_LIBDIR=lib \
         -DCMAKE_NO_SYSTEM_FROM_IMPORTED=ON \
         -DCMAKE_FIND_FRAMEWORK=LAST \
         -DBUILD_SHARED_LIBS=ON \
         -DPYTHON_EXECUTABLE=$PYTHON_EXECUTABLE \
         -DPython3_EXECUTABLE=$PYTHON_EXECUTABLE \
         -DPYTHON_INSTALL_DIR=$SP_DIR \
         -DPKG_CONFIG_EXECUTABLE=$PKG_CONFIG_EXECUTABLE \
         -DSETUPTOOLS_DEB_LAYOUT=OFF \
         -DCATKIN_SKIP_TESTING=$SKIP_TESTING \
         -DCATKIN_BUILD_BINARY_PACKAGE=$CATKIN_BUILD_BINARY_PACKAGE \
         -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
         -G "Ninja" \
         $SRC_DIR/$PKG_NAME/src/work

cmake --build . --config Release --target all

if [[ "$SKIP_TESTING" == "OFF" ]]; then
    cmake --build . --config Release --target run_tests
fi

cmake --build . --config Release --target install

if [ "${PKG_NAME}" == "ros-noetic-catkin" ]; then
    # Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
    # This will allow them to be run on environment activation.
    for CHANGE in "activate" "deactivate"
    do
        mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
        cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
    done

   if [ "${PKG_NAME}" == "ros-noetic-environment" ]; then
       for SCRIPT in "1.ros_distro.sh" "1.ros_etc_dir.sh" "1.ros_package_path.sh" "1.ros_python_version.sh" "1.ros_version.sh"
       do
           cp "${PREFIX}/etc/catkin/profile.d/${SCRIPT}" "${PREFIX}/etc/conda/activate.d/${SCRIPT}"
       done
   fi
fi

if [ "${PKG_NAME}" == "ros-noetic-ros-workspace" ]; then
    # Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
    # This will allow them to be run on environment activation.
    for CHANGE in "activate" "deactivate"
    do
        mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
        cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
    done
fi
