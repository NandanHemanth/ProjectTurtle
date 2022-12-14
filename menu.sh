#!/bin/sh
# User can change this version
export PYTHON_VERSION=3.7.7
export PYTHON_MAJOR=3
pre_requisite()
{
    sudo apt install curl wget cmake git
}
    

rust_install()
{

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

}
# Updates or refreshes everything
update_system()
{
  sudo apt update
  sudo apt upgrade

}
important_lib()
{
  # for apt systems

  sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
       libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
       libncurses5-dev libncursesw5-dev xz-utils tk-dev 
}
# Building Python from Source
python_build()
{
  # Downloading Python
  wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
  tar -xvf Python-$PYTHON_VERSION.tgz
  cd Python-$PYTHON_VERSION
  ./configure --enable-optimizations
  make -j 8
  sudo make altinstall
  # To check the version
  python$PYTHON_MAJOR -V

}
python_pip()
{
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  /opt/python/${PYTHON_VERSION}/bin/python get-pip.py


}
pip_req()
{
  pip3 install -r requirements.txt
}
node_install()
{
  sudo apt install nodejs
}
npm_install()
{
  curl -qL https://www.npmjs.com/install.sh | sh
}
volta_install()
{
    curl https://get.volta.sh | bash
}

docker_prereq()
{
  sudo apt install gnome-terminal
  sudo apt remove docker-desktop
  rm -r $HOME/.docker/desktop
  sudo rm /usr/local/bin/com.docker.cli
  sudo apt purge docker-desktop
}
docker_install()
{
  docker_prereq()
  sudo apt-get update
  sudo apt-get install ./docker-desktop-<version>-<arch>.deb
  echo "docker version"
  docker compose version
  docker version
  echo "would you like to open docker on start? (Y/N)"
  read -r DOCKER_STARTUP
  case $DOCKER_STARTUP in 
    
      Y)
        systemctl --user enable docker-desktop
        ;;
      N)
        ;;
  esac

}
update_system
pre_requisite
important_lib
update_system
echo "Do you wish to install Python (Y/N)"
read -r PYTHON_CHOICE
case $PYTHON_CHOICE in

    Y)
        echo "Installing Python and PIP :-)"
        python_build
        python_pip
        ;;
    N)
        echo "Skipping Python Install :-("
        ;;
esac
echo "Do you wish to install Rust (Y/N)"
read -r RUST_CHOICE
case $RUST_CHOICE in

  Y)
    echo "Installing Rust and Cargo :-)"
    rust_install
    ;;
  N)
    echo "Skipping Rust and Cargo"
    ;;
esac

echo "Do you wish to install Node.js and npm (Y/N)"
read -r NPM_CHOICE
case $NPM_CHOICE in

  Y) echo "Installing Node.js and npm :-)"
    node_install
    npm_install
     ;;
  N) echo "Skipping Node.js and npm"
     ;;
esac


echo "Do you wish to install Volta (Y/N)"
read -r VOLTA_CHOICE
case $VOLTA_CHOICE in

  Y) echo "Installing Volta :-)"
    volta_install
     ;;
  N) echo "Skipping Volta"
     ;;
esac

echo "Do you wish to install Docker (Y/N)"
read -r DOCKER_CHOICE
case $DOCKER_CHOICE in

  Y) echo "Installing Docker :-)"
    docker_install
     ;;
  N) echo "Skipping Docker"
     ;;
esac
