#!/bin/zsh

build() {
  # eval $(ssh-agent) && \
  # ssh-add ~/.ssh/GitHub && \
  export DOCKER_BUILDKIT=1 && docker build \
        -t ghcr.io/flo2410/ros2-docker:latest \
        /home/florian/syncthing/Development/ros/ros2-docker/
        #--build-arg CACHEBUST=$(date +%s) \
        # --ssh default=$(echo $SSH_AUTH_SOCK) \
}

run() {
  #xhost local:root

  if [ ${ROS_DOMAIN:+x} ]
  then ;
  else ROS_DOMAIN=0
  fi

  # -v $HOME/.ssh:/root/.ssh \
  pwd_name=${PWD##*/}          # to assign to a variable
  pwd_name=${pwd_name:-/}        # to correct for the case where PWD=/

  docker run --rm -d -i \
    -v $PWD:/pwd/$pwd_name --cap-add=SYS_PTRACE \
    -v /home/florian/syncthing/Development/ros/ros2-docker/home/.zsh_history:/home/ros/.zsh_history \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -w /pwd/$pwd_name \
    -e DISPLAY \
    -e ROS_DOMAIN=$ROS_DOMAIN \
    --security-opt=apparmor:unconfined \
    --security-opt=seccomp:unconfined \
    --ipc=host \
    --network=host \
    --name=ros2-docker \
    --hostname=ros2-docker \
    ghcr.io/flo2410/ros2-docker:latest
   # --device=/dev/ttyUSB0 \
}

exec_into() {
  docker exec -it ros2-docker /bin/zsh
}

stop() {
  docker stop ros2-docker
}

reset() {
  stop
  run
  exec_into
}

if [ "$1" = "run" ]; then
  echo "RUN!"
  run
elif [ "$1" = "build" ]; then
  echo "BUILD!"
  stop
  build
elif [ "$1" = "exec" ]; then
  echo "EXEC!"
  exec_into
elif [ "$1" = "stop" ]; then
  stop
elif [ "$1" = "reset" ]; then
  reset
elif [ "$1" = "" ]; then
  if [ $( docker ps -f name=ros2-docker | wc -l ) -lt 2 ]; then
    run
  fi
  exec_into
fi
