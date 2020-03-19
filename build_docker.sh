#!/bin/bash
ROOT=$(pwd)
UBUNTU_VER_CMD=$(lsb_release -r -s)
#CONTENTER_NAME="g3plc-dev"
CONTENTER_NAME=$2

function printOptions(){
        	echo "
USAGE: $0 [COMMAND] [OPTIONS]
COMMAND:
    build-and-start-dev /start-dev/ list

        build-and-start-dev: build and start-up container
            OPTIONS: contaniner name
            e.g. $0 build-and-start-dev container-name

        start-dev: start and login to container
            OPTIONS: contaniner name
            e.g. $0 start-dev container-name

        list: show all of the containers

OPTIONS
    see for up description
"
	exit 0
}

function auto-login() {
    expect -c "
	        spawn ssh root@$(sudo docker inspect $CONTENTER_NAME | grep '"IPAddress"' | head -1 | awk -F '"' {'print $4'})
	        expect {
	        \"*assword:\" {set timeout 300; send \"password\r\";}
	        \"yes/no\" {send \"yes\r\"; exp_continue;}
	    }

	    interact
	    "
}

case "$1" in
    build-and-start-dev)
        if [ "$2" = "" ]
        then
            echo "Err. Container name is empty, please input container name,
use \"list\" to show current container, and do not use the same container name"
            exit 0
        fi
        if [ "$UBUNTU_VER_CMD" = "18.04" ]
        then
            sed -i -E 's/FROM ubuntu:[[:digit:]]+.[[:digit:]]+/FROM ubuntu:18.04/g' ./docker/dev/Dockerfile
        elif [ "$UBUNTU_VER_CMD" = "16.04" ]
        then
            sed -i -E 's/FROM ubuntu:[[:digit:]]+.[[:digit:]]+/FROM ubuntu:16.04/g' ./docker/dev/Dockerfile
        fi
        cd docker/dev;sudo docker build -t $CONTENTER_NAME .

        sudo docker run -itd --privileged=true --device=/dev/ --device=/sys/ -v ${ROOT}/:/root/$CONTENTER_NAME --name $CONTENTER_NAME $CONTENTER_NAME:latest
	    sudo docker inspect $CONTENTER_NAME | grep '"IPAddress"' | head -1 | awk -F '"' {'print $4'}
    ;;
    start-dev)
        if [ "$2" = "" ]
        then
            echo "Err. Container name is empty, please input container name, use \"list\" to show current container"
            exit 0
        fi
        sudo docker start $(sudo docker ps -a | grep $CONTENTER_NAME | awk '{print $1}')
        auto-login
        if [ "$?" = 0 ]
        then
            exit 0
        fi
        sudo apt-get install expect
        auto-login
    ;;
    list)
        sudo docker ps -a
    ;;
    *)
		printOptions
	;;
esac

