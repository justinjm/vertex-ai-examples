library(bigrquery)
library(gargle)

options(
  gargle_oauth_email = Sys.getenv("GARGLE_EMAIL"),
  gargle_oauth_cache = TRUE
)

scope <- c("https://www.googleapis.com/auth/cloud-platform")
token <- token_fetch(scopes = scope)

bq_auth(token = token)

project_id <- Sys.getenv("GCP_PROJECT_ID")

dataset <- paste(project_id, "bigrquerytest", sep = ".")
table <- paste(dataset, "data", sep = ".")

bq_project_datasets(project_id)

bq_dataset_create(dataset, location = "us-central1")

bq_dataset_exists(dataset)
bq_dataset_tables(dataset)

bq_table_load(table,
              fields = as_bq_fields(                
                list(
                  list(name = "longitude", type = "STRING"),
                  list(name = "latitude", type = "STRING"),
                  list(name = "housing_median_age", type = "STRING"),
                  list(name = "total_rooms", type = "STRING"),
                  list(name = "total_bedrooms", type = "STRING"),
                  list(name = "population", type = "STRING"),
                  list(name = "households", type = "STRING"),
                  list(name = "median_income", type = "STRING"),
                  list(name = "median_house_value", type = "STRING")
                  )
                ),
              nskip = 1,
              source_format = "CSV",
              source_uris = "gs://cloud-samples-data/ai-platform-unified/datasets/tabular/california-housing-tabular-regression.csv",
              create_disposition = "CREATE_IF_NEEDED", 
              write_disposition = "WRITE_TRUNCATE")

bq_table_fields(table)

## cleanup
### delete table
# bq_table_delete(table)
### detele dataset
# bq_dataset_delete(dataset)

## Gargle 
# https://github.com/r-lib/gargle
# https://gargle.r-lib.org/articles/how-gargle-gets-tokens.html#credentials_app_default
# https://gargle.r-lib.org/articles/how-gargle-gets-tokens.html#credentials_service_account

## bigrquery
# https://github.com/r-dbi/bigrquery

## misc
# https://stackoverflow.com/questions/51181966/r-to-bigquery-data-upload-error