# Predicting customer propensity to buy by using BigQuery ML and AI Platform

DEPRECATED: this tutorial is outdated (uses GA 360, pre-aggregated dataset). See [02-bqml/bqml-churn-ga4.ipynb](/02-bqml/04_bqml_ga4_gaming_churn.ipynb) for updated version.

[Predicting customer propensity to buy by using BigQuery ML and AI Platform | Cloud Architecture Center | Google Cloud](https://cloud.google.com/architecture/predicting-customer-propensity-to-buy)

## Create BQ dataset

```sh
bq --location=US mk \
--dataset \
--description "Demo of BigQuery ML for propensity to purchase" \
demos-vertex-ai:propensity_demo
```

## Create Training dataset

Saved query: `propensity_demo_01_data_training`

```sql

# select initial features and label to feed into your model
CREATE OR REPLACE TABLE propensity_demo.data_training AS
  SELECT
    fullVisitorId,
    bounces,
    time_on_site,
    will_buy_on_return_visit
  FROM (
        # select features
        SELECT
          fullVisitorId,
          IFNULL(totals.bounces, 0) AS bounces,
          IFNULL(totals.timeOnSite, 0) AS time_on_site
        FROM
          `data-to-insights.ecommerce.web_analytics`
        WHERE
          totals.newVisits = 1
        AND date BETWEEN '20160801' # train on first 9 months of data
        AND '20170430'
       )
  JOIN (
        SELECT
          fullvisitorid,
          IF (
              COUNTIF (
                       totals.transactions > 0
                       AND totals.newVisits IS NULL
                      ) > 0,
              1,
              0
             ) AS will_buy_on_return_visit
        FROM
          `bigquery-public-data.google_analytics_sample.*`
        GROUP BY
          fullvisitorid
       )
  USING (fullVisitorId)
  ORDER BY time_on_site DESC
```

## Create Model

Saved query: `propensity_demo_02_create_model`

```sql
CREATE OR REPLACE MODEL `propensity_demo.model_01`
OPTIONS(MODEL_TYPE = 'logistic_reg',
        labels = [ 'will_buy_on_return_visit' ]
        )
AS
SELECT * EXCEPT (fullVisitorId)
FROM `propensity_demo.data_training`
```

## Evaluate

Saved query: `propensity_demo_03_eval_model`

```sql
SELECT
  roc_auc,
  # evaluating the auc value based on the scale at http://gim.unmc.edu/dxtests/roc3.htm
  CASE WHEN roc_auc >.9 THEN 'excellent' WHEN roc_auc >.8 THEN 'good'
  WHEN roc_auc >.7 THEN 'fair' WHEN roc_auc >.6 THEN 'poor' ELSE 'fail' END
  AS modelquality
FROM ML.EVALUATE(MODEL `propensity_demo.model_01`)
```

## Create sample batch input

Saved query: `propensity_demo_04_create_batch`

```sql
CREATE OR REPLACE TABLE `propensity_demo.data_batch_01` AS 
SELECT * 
FROM propensity_demo.data_training
WHERE RAND() < 10/555987
```

## Predict

Saved query: `propensity_demo_05_predict_batch`

docs: [The ML.PREDICT function  |  BigQuery ML  |  Google Cloud](https://cloud.google.com/bigquery-ml/docs/reference/standard-sql/bigqueryml-syntax-predict)

```sql 
# predict the inputs (rows) from the input table
SELECT
  fullVisitorId,
  predicted_will_buy_on_return_visit
FROM ML.PREDICT(MODEL propensity_demo.model_01,
(
   SELECT
   fullVisitorId,
   bounces,
   time_on_site
   FROM propensity_demo.data_batch_01
))
```