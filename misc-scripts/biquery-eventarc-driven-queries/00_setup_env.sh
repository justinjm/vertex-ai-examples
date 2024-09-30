#!/bin/bash
# 00_setup_env.sh
source args

## enable APIS ------------------------------------------------------------------
gcloud services enable \
  iam.googleapis.com \
  iamcredentials.googleapis.com \
  monitoring.googleapis.com \
  logging.googleapis.com \
  bigquery.googleapis.com \
  bigquerystorage.googleapis.com \
  bigquerydatatransfer.googleapis.com \


## create bucket ------------------------------------------------------------------
gsutil mb -l ${LOCATION} gs://${BUCKET}

## give default compute engine service account access to bucket
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:$DEFAULT_SVC_ACCOUNT_EMAIL \
    --role roles/storage.objectAdmin \
    --condition="None"
