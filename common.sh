#!/bin/bash 

enableAPIIfNecessary() {
  API_EXISTS=`gcloud services list | grep $1 | wc -l`

  if [ $API_EXISTS -eq 0 ]
  then
    gcloud services enable $1
  fi
}

echo_mesg() {
   echo "  ----- $1 ----  "
}

###
# Utility method to ensure a URL returns HTTP 401
#
# When a HTTP load balancer is defined, there is a period of time needed to ensure all netowrk paths are clear
# and the requests result in happy requests.
###
checkAppIsReady() {
  local OUT=$(gcloud compute instances get-serial-port-output $INSTANCE --zone=$ZONE --start=0)
  local READY=$(echo $OUT | grep "Running on http" | wc -l | xargs)

  while [[ $READY < 1 ]]
  do
    echo "Sleeping while compute instance updates it's tensorflow and a.n.other libraries ...."
    sleep 45
    OUT=$(gcloud compute instances get-serial-port-output $INSTANCE --zone=$ZONE --start=0)
    READY=$(echo $OUT | grep "Running on http" | wc -l | xargs)
  done
}

###
# Method which waits for a VM Instance to start.
#
# It loops until the status of the instances is "RUNNING"
###
waitForInstanceToStart(){
  local INSTANCE_NAME=$1
  local ZONE=`gcloud compute instances list | grep $INSTANCE_NAME | xargs | cut -d ' ' -f2`
  local STATUS=`gcloud compute instances describe $INSTANCE_NAME --zone=${ZONE} | grep "status:" | cut -d ' ' -f2`

  while [[ "$STATUS" != "RUNNING" ]]
  do
    echo "Sleeping while instance starts ...."
    sleep 3
    STATUS=`gcloud compute instances describe $INSTANCE_NAME --zone=${ZONE} | grep "status:" | cut -d ' ' -f2`
  done
}

###
#
# Method which grabs the console output for debugging.
#
###
getInstanceOutput() {
  local INST=$1
  local ZONE=`gcloud compute instances list | grep $INST | xargs | cut -d ' ' -f2`

  gcloud compute instances get-serial-port-output ${INST} --zone=${ZONE}
}
