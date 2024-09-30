# TODO - Set the name of your project
PROJECT_ID="your-project-id" 
# TODO - Set the name of your service account
SA_NAME="bq-scheduler" 
SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" 

# TODO - set target user that will schedule BQ queries
USER_EMAIL="email@company.com" # can also be group 

# Create the service account
gcloud iam service-accounts create $SA_NAME --project $PROJECT_ID

## service account access --------------------------------------------
## Grant the service account project editor permissions
## or `roles/bigquery.jobUser` if minimal required
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member "serviceAccount:${SA_EMAIL}" \
  --role "roles/bigquery.admin" \
  --condition="None"

## user group access --------------------------------------------
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="user:${USER_EMAIL}" \
  --role="roles/bigquery.user"  \
  --condition="None"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="user:${USER_EMAIL}" \
  --role="roles/iam.serviceAccountViewer" \
  --condition="None"

## give users/groups aaccess 
## https://cloud.google.com/iam/docs/service-account-permissions
gcloud iam service-accounts add-iam-policy-binding "${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --member="user:${USER_EMAIL}" \
  --role="roles/iam.serviceAccountUser" \
  --condition="None"
