FROM johannhaselberger/coros:latest

WORKDIR /my_ros_data

ADD files/setup.sh .
ADD files/.Xresources .

ENV TB3_MODEL=burger \
    TURTLEBOT3_MODEL=burger \
    HOME=/my_ros_data \
    NAME_CATKIN_WORKSPACE=/my_ros_data/catkin_ws \
    SHELL=/bin/bash

RUN echo 'echo "[running .bashrc]"' >> .bashrc
RUN echo "source /my_ros_data/setup.sh" >> .bashrc
RUN echo 'xrdb -merge ~/.Xresources' >> .bashrc

RUN mkdir -p catkin_ws/src

WORKDIR /my_ros_data/catkin_ws/src
RUN source /opt/ros/melodic/setup.bash && catkin_init_workspace

WORKDIR /my_ros_data/catkin_ws
RUN source /opt/ros/melodic/setup.bash && catkin_make

WORKDIR /my_ros_data/catkin_ws/src
RUN git clone https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
RUN git clone https://github.com/ROBOTIS-GIT/turtlebot3.git
RUN git clone https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
RUN git clone https://github.com/campusrover/prrexamples.git
RUN git clone https://github.com/campusrover/gen5.git
RUN git clone https://github.com/MoffKalast/rbx1.git

WORKDIR /my_ros_data/catkin_ws
RUN source /opt/ros/melodic/setup.bash && catkin_make

WORKDIR /my_ros_data

RUN sudo apt update
RUN apt -y upgrade
RUN apt -y install ros-melodic-slam-gmapping
RUN apt -y install ros-melodic-map-server
RUN apt -y install ros-melodic-move-base
RUN apt -y install ros-melodic-dwa-local-planner
RUN pip install redis

WORKDIR /my_ros_data/catkin_ws
RUN source /opt/ros/melodic/setup.bash && catkin_make


