#!/bin/bash
# Instal Pre-reqs
sudo apt-get update

PROJECT_ID=`gcloud config list project --format "value(core.project)"`
SCRIPT_NAME=suf-python-face
SERVICE_ACC=$SCRIPT_NAME@$PROJECT_ID
KEY_FILE=$PROJECT_ID-$SCRIPT_NAME.json

createServiceAccount() {
  # Alternately set the API Key env to value defined in the Console (Credntials, Create Credentials)
  gcloud iam service-accounts create $SCRIPT_NAME --display-name=$SCRIPT_NAME
  gcloud projects add-iam-policy-binding $PROJECT_ID --member "serviceAccount:$SERVICE_ACC.iam.gserviceaccount.com" --role "roles/owner"
  gcloud iam service-accounts keys create $KEY_FILE --iam-account $SERVICE_ACC.iam.gserviceaccount.com
  gcloud auth activate-service-account --key-file $KEY_FILE
  export GOOGLE_APPLICATION_CREDENTIALS="/home/${USER}/$KEY_FILE"
}

createServiceAccount

# Get the App
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/codelabs/flex_and_vision

# Create an App Engine Instance
gcloud app create --region=europe-west2

# Create Bucket
export CLOUD_STORAGE_BUCKET=${PROJECT_ID}
sed -i -e 's/<your-cloud-storage-bucket>/'"$CLOUD_STORAGE_BUCKET"'/g' app.yaml
gsutil mb gs://${CLOUD_STORAGE_BUCKET}

# Deploy app
gcloud app deploy -q
