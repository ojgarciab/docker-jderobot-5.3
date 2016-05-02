FROM ubuntu:14.04
MAINTAINER github/ojgarciab

# Use the "noninteractive" debconf frontend
ENV DEBIAN_FRONTEND noninteractive

# apt-fast installer, replace slow apt-get
RUN echo apt-fast;\
    apt-get install -y git make \
    && target=/root/git/apt-fast \
    && git clone https://github.com/varhub/apt-fast.git -b 1.8.4 $target \
    && cd $target \
    && make install \
    && apt-get clean autoclean

# Add Gazebo, JdeRobot and PCL repositories
RUN apt-get update && apt-fast install -y curl software-properties-common && \
  add-apt-repository -y ppa:v-launchpad-jochen-sprickerhof-de/pcl && \
  echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/gazebo-latest.list && \
  curl 'http://packages.osrfoundation.org/gazebo.key' | apt-key add - && \
  echo "deb http://jderobot.org/apt trusty main" > /etc/apt/sources.list.d/jderobot.list && \
  echo "deb-src http://jderobot.org/apt trusty main" >> /etc/apt/sources.list.d/jderobot.list && \
  curl 'http://jderobot.org/apt/jderobot-key.asc' | apt-key add - && \
  sed -i 's/\/archive\.ubuntu\.com/\/es.archive.ubuntu.com/g' /etc/apt/sources.list && \
  apt-get update && apt-fast install -y \
    bash-completion \
    git \
    build-essential \
    vim-nox \
    binutils \
    mesa-utils \
    gazebo5 \
    libgazebo5-dev \
    jderobot-deps-dev \
    libqwt5-qt4-dev && \
  apt-get clean

# some QT-Apps/Gazebo don't not show controls without this
ENV QT_X11_NO_MITSHM 1

