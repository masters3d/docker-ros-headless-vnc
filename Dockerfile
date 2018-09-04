# Source https://github.com/brandeislatte/docker-ros/blob/master/Dockerfile
FROM osrf/ros:kinetic-desktop-full

# Set the locale
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
RUN apt-get update && apt-get install -y \
  ros-kinetic-moveit \
  ros-kinetic-industrial-robot-simulator \
  ros-kinetic-ur-description \
  ros-kinetic-turtlebot* \
  software-properties-common \
  terminator \
  curl \
  wget \
  iputils-ping \
  gitk \
  vim \
  emacs24 \
  sudo \
  libgl1-mesa-glx \
  libgl1-mesa-dri \
  mesa-utils

RUN add-apt-repository -y ppa:levi-armstrong/qt-libraries-xenial \
  && add-apt-repository -y ppa:levi-armstrong/ppa \
  && apt update && apt install -y qt59creator qt57creator-plugin-ros \
  && rm -rf /var/likb/apt/lists/*

# Updating the version of Gazebo7
# http://gazebosim.org/tutorials?cat=install&tut=install_ubuntu&ver=7.0

RUN sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN sudo apt-get update && apt-get install -y \
  gazebo7

# The following came from https://github.com/ConSol/docker-headless-vnc-container/blob/master/Dockerfile.ubuntu.xfce.vnc
# See ./docker/license

LABEL io.k8s.description="Headless VNC Container with Xfce window manager, firefox and chromium" \
      io.k8s.display-name="Headless VNC Container based on Ubuntu" \
      io.openshift.expose-services="6901:http,5901:xvnc" \
      io.openshift.tags="vnc, ubuntu, xfce" \
      io.openshift.non-scalable=true

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

### Envrionment config
ENV HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    NO_VNC_HOME=/headless/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false
WORKDIR $HOME

### Add all install scripts for further steps
ADD ./docker/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

### Install some common tools
RUN $INST_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh

### Install firefox and chrome browser
RUN $INST_SCRIPTS/firefox.sh
RUN $INST_SCRIPTS/chrome.sh

### Install xfce UI
RUN $INST_SCRIPTS/xfce_ui.sh
ADD ./docker/xfce/ $HOME/

### configure startup
RUN $INST_SCRIPTS/libnss_wrapper.sh
ADD ./docker/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME

USER 1000

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]


