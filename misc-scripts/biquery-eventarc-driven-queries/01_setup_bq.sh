#!/bin/bash
# 03_setup_data.sh
source args

## load data into GCS  ---------------------------------
### staging area for loading into BigQuery 
## copy data into GCS bucket ------------------------------------------------------------------
curl https://raw.githubusercontent.com/justinjm/vertex-ai-examples/main/data/${DATA_FILE_CSV} | gsutil cp - gs://${BUCKET}/${DATA_FILE_CSV}

## load data into BQ  ---------------------------------
### create dataset
bq mk ${BQ_DATASET}

### create table - target table
bq load \
    --autodetect=TRUE \
    --skip_leading_rows=1 \
    ${BQ_DATASET}.${BQ_TABLE_DATA} \
    gs://${BUCKET}/${DATA_FILE_CSV}
# https://cloud.google.com/bigquery/docs/reference/bq-cli-reference#bq_load
# https://cloud.google.com/bigquery/docs/bq-command-line-tool