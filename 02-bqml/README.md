# BigQuery ML 

## Quick-start

Read more about BigQuery ML below: 

* [What is BigQuery ML?  |  Google Cloud](https://cloud.google.com/bigquery-ml/docs/introduction) 
* [End-to-end user journey for each model  |  BigQuery ML  |  Google Cloud](https://cloud.google.com/bigquery-ml/docs/reference/standard-sql/bigqueryml-syntax-e2e-journey)

## Steps

1. Create BigQuery Dataset 
2. Create BigQuery table (`bigquery-public-data.ml_datasets.ulb_fraud_detection`)
3. Train Model and upload to Vertex AI Model Registry

### Variables 

Replace the following values below with your own: 

* `<your-project-id>` 
* `<your-model-id>`
* `<your-model-version-alias>`

## 1. Create BigQuery Dataset 

* [Introduction to SQL in BigQuery  |  Google Cloud](https://cloud.google.com/bigquery/docs/reference/standard-sql/introduction)
* [Creating datasets  |  BigQuery  |  Google Cloud](https://cloud.google.com/bigquery/docs/datasets#sql)

```sql
#standardSQL
CREATE SCHEMA `<your-project-id>.feature_engineering`
  OPTIONS (
    location = "us"
  )
```

## 2. Create BigQuery Table 

* [Create and use tables  |  BigQuery  |  Google Cloud](https://cloud.google.com/bigquery/docs/tables#sql)

```sql 
#standardSQL
CREATE TABLE `<your-project-id>.feature_engineering.fraud` AS
    SELECT *
    FROM `bigquery-public-data.ml_datasets.ulb_fraud_detection`
```

## 3. Train model and upload to Vertex AI Model Registry

* [End-to-end user journey for each model  |  BigQuery ML  |  Google Cloud](https://cloud.google.com/bigquery-ml/docs/reference/standard-sql/bigqueryml-syntax-e2e-journey)
* [The CREATE MODEL statement  |  BigQuery ML  |  Google Cloud](https://cloud.google.com/bigquery-ml/docs/reference/standard-sql/bigqueryml-syntax-create)

```sql
#standardSQL
CREATE MODEL `<your-project-id>.feature_engineering.<your-model-id>_<your-model-version-alias>`
OPTIONS (
        model_type = 'LOGISTIC_REG',
        auto_class_weights = TRUE,
        input_label_cols = ['Class'],
        enable_global_explain = TRUE,
        data_split_method = 'AUTO_SPLIT',
        MODEL_REGISTRY = 'VERTEX_AI',
        VERTEX_AI_MODEL_ID = '<your-model-id>',
        VERTEX_AI_MODEL_VERSION_ALIASES = ['<your-model-version-alias>']
    ) AS
SELECT *
FROM `<your-project-id>.feature_engineering.fraud`
```

## Acknowledgements

Inspired by original source code by: [statmike](https://github.com/statmike/vertex-ai-mlops/blob/main/Dev/BQML%20Feature%20Engineering.ipynb)
