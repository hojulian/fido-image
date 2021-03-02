# Build easy-novnc
FROM golang:1.15-buster AS easy-novnc-build

RUN git clone https://github.com/pgaskin/easy-novnc.git /easy-novnc
WORKDIR /easy-novnc
RUN go mod download && \
    go build -o /bin/easy-novnc .

# Build image
FROM osrf/ros:melodic-desktop-full-bionic

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash"

# update ubuntu and install all dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        tigervnc-standalone-server \
        openbox \
        supervisor \
        mesa-utils \
        libglu1-mesa \
        xterm \
        python \
        python3.8 \
        python-pip \
        wget \
        ros-melodic-image-transport \
        ros-melodic-cv-bridge \
        ros-melodic-rqt \
        ros-melodic-rqt* \
        ros-melodic-rviz

# copy easy-novnc
COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/

WORKDIR /workspace

# set the environment variables (display -> 99)
ENV DISPLAY=":99" \
    PASSWORD="dev@ros" \
    HOME="/workspace" \
    NAME_CATKIN_WORKSPACE=/workspace/catkin_ws

# source ros for every new terminal session
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

# set our workdir
WORKDIR /workspace/catkin_ws/src
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && catkin_init_workspace"

WORKDIR /workspace/catkin_ws
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && catkin_make"

WORKDIR /workspace

# add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/bin/supervisord", "-n"]

COPY ./supervisord.conf /etc/
