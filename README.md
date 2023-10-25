# ros2-docker
My ROS2 Humble docker container.

I use this as my ROS2 environment on my laptop, as well as a devcontainer for vs code.

## Usage

To be able to use the script from anywhere, symlink it to some folder in your `path` or ad an alias to your `.bashrc` or simmilar.
After that you can run `ros2-docker` to start the container and mount the current working directory to it.
If the container is allready running, `ros2-docker` will just attache a new shell.
To stop the container run `ros2-docker stop`.

If you want to build the container localy, change the directory in the `ros2-docker.sh` file to matche the location on your pc. After that you can run `ros2-docker build` to build it.
