-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### 1. Create filters

-- COMMAND ----------

CREATE WIDGET DROPDOWN vendor_id DEFAULT '1' CHOICES SELECT DISTINCT VendorID FROM taxi_data ORDER BY VendorID;
CREATE WIDGET DROPDOWN pickup_hour DEFAULT '0' CHOICES SELECT DISTINCT pickup_hour FROM taxi_data ORDER BY pickup_hour;

CREATE WIDGET DROPDOWN passenger_count DEFAULT '1' CHOICES SELECT DISTINCT passenger_count FROM taxi_data ORDER BY passenger_count;
CREATE WIDGET DROPDOWN store_and_fwd_flag DEFAULT 'N' CHOICES SELECT DISTINCT store_and_fwd_flag FROM taxi_data ORDER BY store_and_fwd_flag;


-- COMMAND ----------

CREATE WIDGET DROPDOWN payment_type DEFAULT 'Credit card'
CHOICES
SELECT DISTINCT
  CASE payment_type
    WHEN 1 THEN 'Credit card'
    WHEN 2 THEN 'Cash'
    WHEN 3 THEN 'No charge'
    WHEN 4 THEN 'Dispute'
    WHEN 5 THEN 'Unknown'
    WHEN 6 THEN 'Voided trip'
  END AS payment_label
FROM taxi_data
ORDER BY payment_label;

-- COMMAND ----------

CREATE WIDGET DROPDOWN pickup_dayofweek DEFAULT 'Mon'
CHOICES
SELECT DISTINCT
  CASE pickup_dayofweek
    WHEN 1 THEN 'Sun'
    WHEN 2 THEN 'Mon'
    WHEN 3 THEN 'Tue'
    WHEN 4 THEN 'Wed'
    WHEN 5 THEN 'Thu'
    WHEN 6 THEN 'Fri'
    WHEN 7 THEN 'Sat'
  END AS day_name
FROM taxi_data
ORDER BY day_name;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. Counters

-- COMMAND ----------

-- DBTITLE 1,Number of Trips
-- Total Number of Trips
SELECT COUNT(*) AS total_trips
FROM taxi_data
WHERE CAST(VendorID AS STRING) = '${vendor_id}'
  AND CASE payment_type
        WHEN 1 THEN 'Credit card'
        WHEN 2 THEN 'Cash'
        WHEN 3 THEN 'No charge'
        WHEN 4 THEN 'Dispute'
        WHEN 5 THEN 'Unknown'
        WHEN 6 THEN 'Voided trip'
      END = '${payment_type}'
  AND CAST(passenger_count AS STRING) = '${passenger_count}'
  AND CAST(pickup_hour AS STRING) = '${pickup_hour}'
  AND CASE pickup_dayofweek
        WHEN 1 THEN 'Sun'
        WHEN 2 THEN 'Mon'
        WHEN 3 THEN 'Tue'
        WHEN 4 THEN 'Wed'
        WHEN 5 THEN 'Thu'
        WHEN 6 THEN 'Fri'
        WHEN 7 THEN 'Sat'
      END = '${pickup_dayofweek}'
  AND store_and_fwd_flag = '${store_and_fwd_flag}';

-- COMMAND ----------

-- DBTITLE 1,Average Trip Distance
-- Average Trip Distance
SELECT ROUND(AVG(trip_distance), 2) AS avg_trip_distance FROM taxi_data
WHERE CAST(VendorID AS STRING) = '${vendor_id}'
  AND CASE payment_type
        WHEN 1 THEN 'Credit card'
        WHEN 2 THEN 'Cash'
        WHEN 3 THEN 'No charge'
        WHEN 4 THEN 'Dispute'
        WHEN 5 THEN 'Unknown'
        WHEN 6 THEN 'Voided trip'
      END = '${payment_type}'
  AND CAST(passenger_count AS STRING) = '${passenger_count}'
  AND CAST(pickup_hour AS STRING) = '${pickup_hour}'
  AND CASE pickup_dayofweek
        WHEN 1 THEN 'Sun'
        WHEN 2 THEN 'Mon'
        WHEN 3 THEN 'Tue'
        WHEN 4 THEN 'Wed'
        WHEN 5 THEN 'Thu'
        WHEN 6 THEN 'Fri'
        WHEN 7 THEN 'Sat'
      END = '${pickup_dayofweek}'
  AND store_and_fwd_flag = '${store_and_fwd_flag}';

-- COMMAND ----------

-- DBTITLE 1,Average Fare
-- Average Fare Amount
SELECT ROUND(AVG(fare_amount), 2) AS avg_fare FROM taxi_data
WHERE CAST(VendorID AS STRING) = '${vendor_id}'
  AND CASE payment_type
        WHEN 1 THEN 'Credit card'
        WHEN 2 THEN 'Cash'
        WHEN 3 THEN 'No charge'
        WHEN 4 THEN 'Dispute'
        WHEN 5 THEN 'Unknown'
        WHEN 6 THEN 'Voided trip'
      END = '${payment_type}'
  AND CAST(passenger_count AS STRING) = '${passenger_count}'
  AND CAST(pickup_hour AS STRING) = '${pickup_hour}'
  AND CASE pickup_dayofweek
        WHEN 1 THEN 'Sun'
        WHEN 2 THEN 'Mon'
        WHEN 3 THEN 'Tue'
        WHEN 4 THEN 'Wed'
        WHEN 5 THEN 'Thu'
        WHEN 6 THEN 'Fri'
        WHEN 7 THEN 'Sat'
      END = '${pickup_dayofweek}'
  AND store_and_fwd_flag = '${store_and_fwd_flag}';

-- COMMAND ----------

-- DBTITLE 1,Total Revenue
-- Total Revenue 
SELECT ROUND(SUM(total_amount), 2) AS total_revenue
FROM taxi_data
WHERE CAST(VendorID AS STRING) = '${vendor_id}'
  AND CASE payment_type
        WHEN 1 THEN 'Credit card'
        WHEN 2 THEN 'Cash'
        WHEN 3 THEN 'No charge'
        WHEN 4 THEN 'Dispute'
        WHEN 5 THEN 'Unknown'
        WHEN 6 THEN 'Voided trip'
      END = '${payment_type}'
  AND CAST(passenger_count AS STRING) = '${passenger_count}'
  AND CAST(pickup_hour AS STRING) = '${pickup_hour}'
  AND CASE pickup_dayofweek
        WHEN 1 THEN 'Sun'
        WHEN 2 THEN 'Mon'
        WHEN 3 THEN 'Tue'
        WHEN 4 THEN 'Wed'
        WHEN 5 THEN 'Thu'
        WHEN 6 THEN 'Fri'
        WHEN 7 THEN 'Sat'
      END = '${pickup_dayofweek}'
  AND store_and_fwd_flag = '${store_and_fwd_flag}';

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3. Temporal Patterns – Taxi Demand by Time

-- COMMAND ----------

-- DBTITLE 1,Taxi Demand by Hour
-- Hourly Demand
SELECT 
  pickup_hour,
  COUNT(*) AS total_trips
FROM taxi_data
-- WHERE CAST(VendorID AS STRING) = '${vendor_id}'
--   AND CASE payment_type
--         WHEN 1 THEN 'Credit card'
--         WHEN 2 THEN 'Cash'
--         WHEN 3 THEN 'No charge'
--         WHEN 4 THEN 'Dispute'
--         WHEN 5 THEN 'Unknown'
--         WHEN 6 THEN 'Voided trip'
--       END = '${payment_type}'
--   AND CAST(passenger_count AS STRING) = '${passenger_count}'
--   -- AND CAST(pickup_hour AS STRING) = '${pickup_hour}'
--   AND CASE pickup_dayofweek
--         WHEN 1 THEN 'Sun'
--         WHEN 2 THEN 'Mon'
--         WHEN 3 THEN 'Tue'
--         WHEN 4 THEN 'Wed'
--         WHEN 5 THEN 'Thu'
--         WHEN 6 THEN 'Fri'
--         WHEN 7 THEN 'Sat'
--       END = '${pickup_dayofweek}'
-- AND store_and_fwd_flag = '${store_and_fwd_flag}'
GROUP BY pickup_hour
ORDER BY pickup_hour


-- COMMAND ----------

-- MAGIC %md
-- MAGIC The analysis of hourly taxi demand shows that trip volume is lowest between 2 AM and 6 AM, then steadily increases through the morning commute, peaking between 6 PM and 9 PM, with the highest activity at 7 PM (over 800,000 rides).
-- MAGIC
-- MAGIC These patterns clearly identify optimal windows for:
-- MAGIC
-- MAGIC - Fleet Deployment: Increase driver availability during evening peaks to meet demand and reduce passenger wait times.
-- MAGIC
-- MAGIC - Surge Pricing Models: Apply dynamic pricing during peak hours (especially post-work hours and nightlife) to balance supply and demand.
-- MAGIC
-- MAGIC - Predictive Dispatching: Use historical patterns to forecast ride demand and position vehicles preemptively in high-demand zones during peak times.

-- COMMAND ----------

-- DBTITLE 1,Taxi demand by day of week
-- Daily Demand
SELECT 
  pickup_dayofweek,
  CASE pickup_dayofweek
    WHEN 1 THEN 'Sunday'
    WHEN 2 THEN 'Monday'
    WHEN 3 THEN 'Tuesday'
    WHEN 4 THEN 'Wednesday'
    WHEN 5 THEN 'Thursday'
    WHEN 6 THEN 'Friday'
    WHEN 7 THEN 'Saturday'
  END AS day,
  COUNT(*) AS daily_trips
FROM taxi_data
-- WHERE CAST(VendorID AS STRING) = '${vendor_id}'
--   AND CASE payment_type
--         WHEN 1 THEN 'Credit card'
--         WHEN 2 THEN 'Cash'
--         WHEN 3 THEN 'No charge'
--         WHEN 4 THEN 'Dispute'
--         WHEN 5 THEN 'Unknown'
--         WHEN 6 THEN 'Voided trip'
--       END = '${payment_type}'
--   AND CAST(passenger_count AS STRING) = '${passenger_count}'
--   AND CAST(pickup_hour AS STRING) = '${pickup_hour}'
--   -- AND CASE pickup_dayofweek
--   --       WHEN 1 THEN 'Sun'
--   --       WHEN 2 THEN 'Mon'
--   --       WHEN 3 THEN 'Tue'
--   --       WHEN 4 THEN 'Wed'
--   --       WHEN 5 THEN 'Thu'
--   --       WHEN 6 THEN 'Fri'
--   --       WHEN 7 THEN 'Sat'
--   --     END = '${pickup_dayofweek}'
--   AND store_and_fwd_flag = '${store_and_fwd_flag}'
GROUP BY pickup_dayofweek
ORDER BY pickup_dayofweek

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Taxi demand is highest on weekends, especially Saturdays, with over 2.3 million trips, and lowest on Mondays. This suggests that weekend surge pricing and increased fleet deployment would be highly effective. Weekdays like Monday and Tuesday may benefit from promotional pricing or reduced fleet to optimize costs.
-- MAGIC
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###  4. Spatial Patterns – Frequent Pickup/Drop-off Zones

-- COMMAND ----------

-- DBTITLE 1,Frequent Pickup/Drop-off Zones
SELECT 
  ROUND(pickup_latitude, 2) AS lat, 
  ROUND(pickup_longitude, 2) AS lon,
  COUNT(*) AS pickup_count
FROM taxi_data
-- WHERE CAST(VendorID AS STRING) = '${vendor_id}'
--   AND CASE payment_type
--         WHEN 1 THEN 'Credit card'
--         WHEN 2 THEN 'Cash'
--         WHEN 3 THEN 'No charge'
--         WHEN 4 THEN 'Dispute'
--         WHEN 5 THEN 'Unknown'
--         WHEN 6 THEN 'Voided trip'
--       END = '${payment_type}'
--   AND CAST(passenger_count AS STRING) = '${passenger_count}'
--   AND CAST(pickup_hour AS STRING) = '${pickup_hour}'
--   AND CASE pickup_dayofweek
--         WHEN 1 THEN 'Sun'
--         WHEN 2 THEN 'Mon'
--         WHEN 3 THEN 'Tue'
--         WHEN 4 THEN 'Wed'
--         WHEN 5 THEN 'Thu'
--         WHEN 6 THEN 'Fri'
--         WHEN 7 THEN 'Sat'
--       END = '${pickup_dayofweek}'
--   AND store_and_fwd_flag = '${store_and_fwd_flag}'
GROUP BY lat, lon
ORDER BY pickup_count DESC
LIMIT 20

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 5. Trip Duration & Congestion by Time/Location

-- COMMAND ----------

-- DBTITLE 1,Average trip duration by hour
SELECT 
  pickup_hour,
  AVG(trip_duration) AS avg_duration
FROM taxi_data
-- WHERE CAST(VendorID AS STRING) = '${vendor_id}'
--   AND CASE payment_type
--         WHEN 1 THEN 'Credit card'
--         WHEN 2 THEN 'Cash'
--         WHEN 3 THEN 'No charge'
--         WHEN 4 THEN 'Dispute'
--         WHEN 5 THEN 'Unknown'
--         WHEN 6 THEN 'Voided trip'
--       END = '${payment_type}'
--   AND CAST(passenger_count AS STRING) = '${passenger_count}'
--   -- AND CAST(pickup_hour AS STRING) = '${pickup_hour}'
--   AND CASE pickup_dayofweek
--         WHEN 1 THEN 'Sun'
--         WHEN 2 THEN 'Mon'
--         WHEN 3 THEN 'Tue'
--         WHEN 4 THEN 'Wed'
--         WHEN 5 THEN 'Thu'
--         WHEN 6 THEN 'Fri'
--         WHEN 7 THEN 'Sat'
--       END = '${pickup_dayofweek}'
--   AND store_and_fwd_flag = '${store_and_fwd_flag}'
GROUP BY pickup_hour
ORDER BY pickup_hour

-- COMMAND ----------

-- DBTITLE 1,Trip Duration by Hour
--Boxplot Data: Trip Duration by Hour for Short Trips
SELECT
  pickup_hour,
  trip_duration
FROM taxi_data
-- WHERE CAST(VendorID AS STRING) = '${vendor_id}'
--   AND CASE payment_type
--         WHEN 1 THEN 'Credit card'
--         WHEN 2 THEN 'Cash'
--         WHEN 3 THEN 'No charge'
--         WHEN 4 THEN 'Dispute'
--         WHEN 5 THEN 'Unknown'
--         WHEN 6 THEN 'Voided trip'
--       END = '${payment_type}'
--   AND CAST(passenger_count AS STRING) = '${passenger_count}'
--   -- AND CAST(pickup_hour AS STRING) = '${pickup_hour}'
--   AND CASE pickup_dayofweek
--         WHEN 1 THEN 'Sun'
--         WHEN 2 THEN 'Mon'
--         WHEN 3 THEN 'Tue'
--         WHEN 4 THEN 'Wed'
--         WHEN 5 THEN 'Thu'
--         WHEN 6 THEN 'Fri'
--         WHEN 7 THEN 'Sat'
--       END = '${pickup_dayofweek}'
--   AND store_and_fwd_flag = '${store_and_fwd_flag}';

-- COMMAND ----------

-- DBTITLE 1,Congested Pickup Areas for Short Trips with Long Duration
-- Congested Pickup Areas for Short Trips with Long Duration
SELECT
  ROUND(pickup_latitude, 2) AS lat_bin,
  ROUND(pickup_longitude, 2) AS lon_bin,
  COUNT(*) AS trip_count
FROM taxi_data
WHERE trip_distance < 1 AND trip_duration > 20
  -- AND CAST(VendorID AS STRING) = '${vendor_id}'
  -- AND CASE payment_type
  --       WHEN 1 THEN 'Credit card'
  --       WHEN 2 THEN 'Cash'
  --       WHEN 3 THEN 'No charge'
  --       WHEN 4 THEN 'Dispute'
  --       WHEN 5 THEN 'Unknown'
  --       WHEN 6 THEN 'Voided trip'
  --     END = '${payment_type}'
  -- AND CAST(passenger_count AS STRING) = '${passenger_count}'
  -- AND CAST(pickup_hour AS STRING) = '${pickup_hour}'
  -- AND CASE pickup_dayofweek
  --       WHEN 1 THEN 'Sun'
  --       WHEN 2 THEN 'Mon'
  --       WHEN 3 THEN 'Tue'
  --       WHEN 4 THEN 'Wed'
  --       WHEN 5 THEN 'Thu'
  --       WHEN 6 THEN 'Fri'
  --       WHEN 7 THEN 'Sat'
  --     END = '${pickup_dayofweek}'
  -- AND store_and_fwd_flag = '${store_and_fwd_flag}'
GROUP BY lat_bin, lon_bin
ORDER BY trip_count DESC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 6. Correlation analysis

-- COMMAND ----------

-- Correlation heatmap for the full data 
SELECT * FROM correlation_matrix_view
ORDER BY correlation DESC;

-- COMMAND ----------

-- Corelation analysis for filtered data
-- Compute the correlation matrix with filters applied
WITH filtered_data AS (
    SELECT 
        trip_distance, 
        fare_amount, 
        tip_amount, 
        tolls_amount, 
        trip_duration, 
        total_amount
    FROM taxi_data
    WHERE CAST(VendorID AS STRING) = '${vendor_id}'
      -- AND CASE payment_type
      --       WHEN 1 THEN 'Credit card'
      --       WHEN 2 THEN 'Cash'
      --       WHEN 3 THEN 'No charge'
      --       WHEN 4 THEN 'Dispute'
      --       WHEN 5 THEN 'Unknown'
      --       WHEN 6 THEN 'Voided trip'
      --     END = '${payment_type}'
      AND CAST(passenger_count AS STRING) = '${passenger_count}'
      AND CAST(pickup_hour AS STRING) = '${pickup_hour}'
      AND CASE pickup_dayofweek
            WHEN 1 THEN 'Sun'
            WHEN 2 THEN 'Mon'
            WHEN 3 THEN 'Tue'
            WHEN 4 THEN 'Wed'
            WHEN 5 THEN 'Thu'
            WHEN 6 THEN 'Fri'
            WHEN 7 THEN 'Sat'
          END = '${pickup_dayofweek}'
      AND store_and_fwd_flag = '${store_and_fwd_flag}'
)
SELECT 
    corr(trip_distance, fare_amount) AS corr_trip_distance_fare_amount, 
    corr(trip_distance, tip_amount) AS corr_trip_distance_tip_amount,
    corr(trip_distance, tolls_amount) AS corr_trip_distance_tolls_amount,
    corr(fare_amount, tip_amount) AS corr_fare_amount_tip_amount,
    corr(fare_amount, tolls_amount) AS corr_fare_amount_tolls_amount,
    corr(tip_amount, tolls_amount) AS corr_tip_amount_tolls_amount,
    corr(trip_duration, total_amount) AS corr_trip_duration_total_amount
FROM filtered_data;




-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW correlation_results AS
WITH filtered_data AS (
    SELECT 
        trip_distance, 
        fare_amount, 
        tip_amount, 
        tolls_amount, 
        trip_duration, 
        total_amount
    FROM taxi_data
    WHERE CAST(VendorID AS STRING) = '${vendor_id}'
      AND CAST(passenger_count AS STRING) = '${passenger_count}'
      AND CAST(pickup_hour AS STRING) = '${pickup_hour}'
      AND CASE pickup_dayofweek
            WHEN 1 THEN 'Sun'
            WHEN 2 THEN 'Mon'
            WHEN 3 THEN 'Tue'
            WHEN 4 THEN 'Wed'
            WHEN 5 THEN 'Thu'
            WHEN 6 THEN 'Fri'
            WHEN 7 THEN 'Sat'
          END = '${pickup_dayofweek}'
      AND store_and_fwd_flag = '${store_and_fwd_flag}'
)
SELECT 
    corr(trip_distance, fare_amount) AS corr_trip_distance_fare_amount, 
    corr(trip_distance, tip_amount) AS corr_trip_distance_tip_amount,
    corr(trip_distance, tolls_amount) AS corr_trip_distance_tolls_amount,
    corr(fare_amount, tip_amount) AS corr_fare_amount_tip_amount,
    corr(fare_amount, tolls_amount) AS corr_fare_amount_tolls_amount,
    corr(tip_amount, tolls_amount) AS corr_tip_amount_tolls_amount,
    corr(trip_duration, total_amount) AS corr_trip_duration_total_amount
FROM filtered_data;

-- COMMAND ----------

-- MAGIC %python
-- MAGIC import pandas as pd
-- MAGIC import seaborn as sns
-- MAGIC import matplotlib.pyplot as plt
-- MAGIC
-- MAGIC # Query the correlation results from the temporary view
-- MAGIC correlation_query = """
-- MAGIC SELECT * FROM correlation_results
-- MAGIC """
-- MAGIC
-- MAGIC # Execute the SQL query and convert the result to a Pandas DataFrame
-- MAGIC correlation_result = spark.sql(correlation_query).toPandas()
-- MAGIC
-- MAGIC # Reshape the correlation result into a matrix format (for heatmap)
-- MAGIC # Since the result is a single row, we manually create a 2D array
-- MAGIC correlation_matrix = correlation_result.values.reshape(1, -1)
-- MAGIC
-- MAGIC # Create a DataFrame for visualization purposes
-- MAGIC correlation_df = pd.DataFrame(correlation_matrix, columns=correlation_result.columns)
-- MAGIC
-- MAGIC # Plot the heatmap using Seaborn
-- MAGIC plt.figure(figsize=(10, 7))
-- MAGIC sns.heatmap(correlation_df, annot=True, cmap='coolwarm', vmin=-1, vmax=1, fmt='.2f', linewidths=0.5)
-- MAGIC
-- MAGIC # Add a title
-- MAGIC plt.title('Filterred Correlation Matrix Heatmap', fontsize=16)
-- MAGIC plt.xticks(rotation=40, ha="right")
-- MAGIC # Display the plot
-- MAGIC plt.show()

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 7. Taxi Trip Revenue and Tips Breakdown by Payment Type

-- COMMAND ----------

-- DBTITLE 1,Taxi Trip Revenue and Tips Breakdown by Payment Type
SELECT
  CASE payment_type
    WHEN 1 THEN 'Credit card'
    WHEN 2 THEN 'Cash'
    WHEN 3 THEN 'No charge'
    WHEN 4 THEN 'Dispute'
    WHEN 5 THEN 'Unknown'
    WHEN 6 THEN 'Voided trip'
    ELSE 'Other'
  END AS payment_label,
  AVG(tip_amount) AS avg_tip,
  AVG(total_amount) AS avg_total,
  AVG(fare_amount) AS avg_fare
FROM taxi_data
-- WHERE CAST(VendorID AS STRING) = '${vendor_id}'
--   -- AND CASE payment_type
--   --       WHEN 1 THEN 'Credit card'
--   --       WHEN 2 THEN 'Cash'
--   --       WHEN 3 THEN 'No charge'
--   --       WHEN 4 THEN 'Dispute'
--   --       WHEN 5 THEN 'Unknown'
--   --       WHEN 6 THEN 'Voided trip'
--   --     END = '${payment_type}'
--   AND CAST(passenger_count AS STRING) = '${passenger_count}'
--   AND CAST(pickup_hour AS STRING) = '${pickup_hour}'
--   AND CASE pickup_dayofweek
--         WHEN 1 THEN 'Sun'
--         WHEN 2 THEN 'Mon'
--         WHEN 3 THEN 'Tue'
--         WHEN 4 THEN 'Wed'
--         WHEN 5 THEN 'Thu'
--         WHEN 6 THEN 'Fri'
--         WHEN 7 THEN 'Sat'
--       END = '${pickup_dayofweek}'
--   AND store_and_fwd_flag = '${store_and_fwd_flag}'
GROUP BY payment_type
ORDER BY payment_label;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC

-- COMMAND ----------



-- COMMAND ----------

