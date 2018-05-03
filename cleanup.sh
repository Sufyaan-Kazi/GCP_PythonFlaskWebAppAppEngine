#!/bin/bash 

# Author: Sufyaan Kazi
# Date: March 2018
# Purpose: Removes the $BE_TAG and $FE_TAG deployments

. ./common.sh

echo_mesg "Performing Cleanup if necessary"
PROJECT_ID=`gcloud config list project --format "value(core.project)"`
SCRIPT_NAME=suf-python-face
SERVICE_ACC=$SCRIPT_NAME@$PROJECT_ID

gcloud iam service-accounts delete $SERVICE_ACC.iam.gserviceaccount.com -q
gsutil rb -f gs://$PROJECT_ID/

echo_mesg " ********** Remember to remove DataStore entities *********"

echo_mesg "Cleanup Complete"
