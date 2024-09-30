#!/bin/bash

source args

### create table - target table
bq load \
    --autodetect=TRUE \
    --skip_leading_rows=1 \
    ${BQ_DATASET}.${BQ_TABLE_DATA} \
    gs://${BUCKET}/${DATA_FILE_CSV}