#!/bin/bash 

# Author: Sufyaan Kazi
# Date: April 2018
# Purpose: Deploy a Python Flask web application to the App Engine Flexible environment. 
# The example application allows a user to upload a photo of a person's face and learn how likely it is that the person is happy.
# The application uses Google Cloud APIs for Vision, Storage, and Datastore.

#Load in vars and common functions
. ./common.sh
gcloud auth login

# Start
. ./cleanup.sh

enableAPIIfNecessary appengine.googleapis.com
enableAPIIfNecessary iam.googleapis.com
enableAPIIfNecessary cloudresourcemanager.googleapis.com
enableAPIIfNecessary vision.googleapis.com

