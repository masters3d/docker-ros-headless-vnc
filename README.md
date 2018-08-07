## Docker Hub
https://hub.docker.com/r/masters3d/ros-kinetic-cheyo-image/

`docker pull masters3d/ros-kinetic-cheyo-image`

## Build my Own image
`docker build -t ros-kinetic-cheyo-image .`

Change ros-kinetic-cheyo-image to the name you want the imaged to be called. 

## Run and mount a directory
`docker run -it --user 0 -p 5901:5901 -p 6901:6901 -v /Volumes/somepath:/somenameforpath masters3d/ros-kinetic-cheyo-image:latest -e VNC_RESOLUTION=1280x768 /bin/bash`

I taged my image as `masters3d/ros-kinetic-cheyo-image` but you should be able to change this name with your local image. 

## Source 

ROS  
https://github.com/brandeislatte/docker-ros/blob/master/Dockerfile

VNC Headless  
https://github.com/ConSol/docker-headless-vnc-container/blob/master/Dockerfile.ubuntu.xfce.vnc


