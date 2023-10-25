ARG ROS_DISTRO=humble

FROM althack/ros2:$ROS_DISTRO-full 

# ** USER ROOT **
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update \
   && apt -y install --no-install-recommends \
        nano \
        libserial-dev

RUN apt install -y \
        ros-$ROS_DISTRO-teleop-twist-keyboard \
        ros-$ROS_DISTRO-rviz2 \
        ros-$ROS_DISTRO-rviz-common \
        ros-$ROS_DISTRO-rviz-default-plugins \
        ros-$ROS_DISTRO-rviz-visual-tools \
        ros-$ROS_DISTRO-rviz-rendering \
        ros-$ROS_DISTRO-nav2-rviz-plugins \
        ros-$ROS_DISTRO-navigation2 \ 
        ros-$ROS_DISTRO-nav2-bringup \
        ros-$ROS_DISTRO-slam-toolbox \
        ros-$ROS_DISTRO-rmw-cyclonedds-cpp \
        ros-$ROS_DISTRO-urdf-launch


RUN usermod -aG dialout ros

# ** USER ROS **
USER ros
ENV USER=ros

RUN mkdir -p ~/.ssh && ssh-keyscan -T 10 github.com >> ~/.ssh/known_hosts

# setup dotfiles
# RUN --mount=type=ssh,required=true,mode=0666 git clone git@github.com:Flo2410/dotfiles.git --recurse-submodules ~/dotfiles && \
RUN git clone https://github.com/Flo2410/dotfiles.git --recurse-submodules ~/dotfiles && \
    cd ~/dotfiles && \
    ./install-profile mjölnir

# Clean up
RUN sudo apt autoremove -y \
   && sudo apt clean -y \
   && sudo rm -rf /var/lib/apt/lists/*

RUN echo export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp >> ~/.zshrc && \
    echo source /opt/ros/$ROS_DISTRO/setup.zsh >> ~/.zshrc

ENV DEBIAN_FRONTEND=dialog

# Set up auto-source of workspace for ros user
WORKDIR /pwd
