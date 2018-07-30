#!/bin/bash
set -e

CONTAINER_NAME="LineageOS"
IMAGE_TAG="lineageos:latest"

LINEAGEOS_VOLUME="lineageos"

usage() {
    echo "Usage $0: [Container Name] [Image Tag] [LineageOS Volume]"
}

if [ ! -z "$1" ] ; then
    CONTAINER_NAME=$1
fi
if [ ! -z "$2" ] ; then
    IMAGE_TAG=$2
fi
if [ ! -z "$3" ] ; then
    LINEAGEOS_VOLUME=$3
fi

echo "===================================================="
echo "= Container Name: $CONTAINER_NAME"
echo "= Image Tag: $IMAGE_TAG"
echo "= LineageOS Volume: $LINEAGEOS_VOLUME"
echo "===================================================="
read -p "Do you wish to continue with these parameters? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
    echo "Exiting utility" ; exit 1
fi

echo "Generating LineageOS build environment..."
docker build \
	--tag $IMAGE_TAG \
	.

echo "Running LineageOS container..."
docker run \
	--detach=true \
	--name "$CONTAINER_NAME" \
	--volume $LINEAGEOS_VOLUME:/srv \
	--interactive \
	--tty \
	$IMAGE_TAG
