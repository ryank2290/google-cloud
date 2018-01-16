#!/bin/bash

DISK_NAME=$1
DISK_SIZE=$2
DISK_TYPE=$3
INSTANCE_NAME=$4

# Check that we have got Google Cloud SDK installed.

function checkGoogleCloudAuth {
    if [ $(gcloud config list account --format "value(core.account)") ]; then
        echo -e "Congratulations you are logged in and ready to go."
    else
        echo -e "You are not logged into Google Cloud, please login and try again."
        kill -INT $$
    fi
}

function checkGoogleCloudInstalled {
    echo -e "Checking that the Google Cloud SDK is installed..."
    if which gcloud >/dev/null; then
        echo -e "Looks like gcloud is installed."
        checkGoogleCloudAuth
    else
        echo -e "Looks like gcloud is not installed, please install it."
        kill -INT $$
    fi
}

checkGoogleCloudInstalled

# Create a new disk within Google Cloud Platform.

if [[ ! -z "$DISK_NAME" && "$DISK_SIZE" && "$DISK_TYPE" ]]; then
    gcloud compute disks create ${DISK_NAME} --size ${DISK_SIZE} --type ${DISK_TYPE}
else
    echo -e "Cannot create disk - because no arguements have been supplied."
    kill -INT $$
fi

# Attach a disk to an instance within Google Cloud Platform.

if [[ ! -z "$INSTANCE_NAME" && "$DISK_NAME" ]]; then
    gcloud compute instances attach-disk ${INSTANCE_NAME} --disk ${DISK_NAME}
else
    echo -e "Cannot attach disk to instance - because no arguements have been supplied."
    kill -INT $$
fi

echo -e "Your disk: ${DISK_NAME} has been successfully attached to ${INSTANCE_NAME}."
