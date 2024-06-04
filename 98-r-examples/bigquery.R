# prerequiste: set constants 
# to run this script, you need to either:
# 1) create an .Renviron file with the following and save in the root directory of your local project:
## # .Renviron
## GARGLE_EMAIL = "your_email"
## GCP_PROJECT_ID = "your_project_id"
# OR 
# 2) manually set constants below with "your-project-id" and "your-email" 

## set constants
## manually set these if not using .Renviron file
PROJECT_ID  <- Sys.getenv("GCP_PROJECT_ID")
GARGLE_EMAIL <- Sys.getenv("GARGLE_EMAIL")

LOCATION <- "us-central1"
DATASET_NAME <- "bigrquerytest"
TABLE_NAME <- "data"

## install packages if needed
required_packages <- c("gargle", "bigrquery")
install.packages(setdiff(required_packages, rownames(installed.packages())))

## load packages
library(bigrquery)
library(gargle)

## set options for auth 
options(
  gargle_oauth_email = GARGLE_EMAIL,
  gargle_oauth_cache = TRUE
)

## set scope and token to fetch for auth
scope <- c("https://www.googleapis.com/auth/cloud-platform")
token <- token_fetch(scopes = scope)

## authentciate with bigquery
bq_auth(token = token)

## create full names to pass into api calls next
dataset <- paste(PROJECT_ID, DATASET_NAME, sep = ".")
table <- paste(dataset, TABLE_NAME, sep = ".")

## get list of datasets in project
bq_project_datasets(PROJECT_ID)

## create an empty dataset in specified location 
bq_dataset_create(dataset, location = LOCATION)

## confirm dataset exists
bq_dataset_exists(dataset)

## get list of tables in dataset (should be empty)
bq_dataset_tables(dataset)

## load data into bigquery from a publicly available sample file
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

## check fields of the  table to confirm data was loaded
bq_table_fields(table)

## set query to fetch data from table
### note: we break the rule of "do not run SELECT *" for demo purposes only,
### this dataset is small and will fall under free tier of BQ processing
query <- sprintf(
  "SELECT * FROM `%s.%s.%s` LIMIT 100",
  PROJECT_ID, DATASET_NAME, TABLE_NAME
)

bq_query_results <- bq_project_query(PROJECT_ID, query)

bq_data <- bq_table_download(bq_query_results)

head(bq_data)

## cleanup 
# uncomment and run the following to delete the created resources 

### delete table
# bq_table_delete(table)

### detele dataset
# bq_dataset_delete(dataset)

### confirm dataset no longer exists
# bq_dataset_exists(dataset)

## Gargle 
# https://github.com/r-lib/gargle
# https://gargle.r-lib.org/articles/how-gargle-gets-tokens.html#credentials_app_default
# https://gargle.r-lib.org/articles/how-gargle-gets-tokens.html#credentials_service_account

## bigrquery
# https://github.com/r-dbi/bigrquery

## misc
# https://stackoverflow.com/questions/51181966/r-to-bigquery-data-upload-error