
## Registry

This image has been pushed to the docker registry

```
https://hub.docker.com/r/masters3d/ros-kinetic-cheyo-image/tags/
```

## Run and mount a directory
```
ENV_DIR_TO_MOUNT=/Volumes/Joses_Stuff/github/Brandeis
docker run -it --user 0 -e VNC_RESOLUTION='1280x768' -p 5901:5901 -p 6901:6901 -v $ENV_DIR_TO_MOUNT:/brandeis masters3d/ros-kinetic-cheyo-image:latest /bin/bash
```

## Build the image
`docker build -t ros-kinetic-cheyo-image .`

Change ros-kinetic-cheyo-image to the name you want the imaged to be called. 

I taged my image as `masters3d/ros-kinetic-cheyo-image` but you should be able to change this name with your local image. 

## Source 

ROS  
https://github.com/brandeislatte/docker-ros/blob/master/Dockerfile

VNC Headless  
https://github.com/ConSol/docker-headless-vnc-container/blob/master/Dockerfile.ubuntu.xfce.vnc


