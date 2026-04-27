# Databricks notebook source
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.stat import Correlation
import pandas as pd

# COMMAND ----------

spark = SparkSession.builder.appName("ALY6110_EDA_Finalproject").getOrCreate()

# COMMAND ----------

# MAGIC %md
# MAGIC # 1. Preprocessing

# COMMAND ----------

# a) Load dataset
df = spark.read.csv("dbfs:/FileStore/tables/yellow_tripdata_2015_01.csv", header=True, inferSchema=True)
df.show(5)

# COMMAND ----------

# b) Show schema
df.printSchema()

# COMMAND ----------

# c) Count number of rows
row_count = df.count()
print(f"Number of rows: {row_count}")

# COMMAND ----------

# MAGIC %md
# MAGIC # 1. Data Cleaning

# COMMAND ----------

# a) Check for nulls and missing values per column

# Define numeric and non-numeric column lists
numeric_cols = [field.name for field in df.schema.fields if str(field.dataType) in ('DoubleType', 'FloatType', 'IntegerType')]
other_cols = [field.name for field in df.schema.fields if field.name not in numeric_cols]

# Count nulls and NaNs for numeric columns
numeric_nulls = df.select([
    count(when(col(c).isNull() | isnan(col(c)), c)).alias(c) for c in numeric_cols
])

# Count only nulls for other (non-numeric) columns
other_nulls = df.select([
    count(when(col(c).isNull(), c)).alias(c) for c in other_cols
])


print("Missing values in numeric columns:")
numeric_nulls.show()

print("Missing values in non-numeric columns:")
other_nulls.show()

# COMMAND ----------

# MAGIC %md
# MAGIC - There are no missing (null) or NaN values in the numeric columns
# MAGIC - improvement_surcharge has 3 missing values. We can fill it with the most common to keep all data and avoid unnecessary row loss 

# COMMAND ----------

# Find the Most Frequent Value in improvement_surcharge
improvement_surcharge_mode = df.groupBy("improvement_surcharge") .count().orderBy("count", ascending=False).first()['improvement_surcharge']
print(improvement_surcharge_mode)

# Ensure value is numeric (in case of implicit type mismatch)
improvement_surcharge_mode = float(improvement_surcharge_mode)

# Re-fill missing values again
df = df.fillna({"improvement_surcharge": improvement_surcharge_mode})

# Check again for missing values
missing_check = df.select([
    count(when(col(c).isNull(), c)).alias(c) for c in df.columns
])
print("Rechecking missing values:")
missing_check.show()

# COMMAND ----------

# check duplicated rows
# Group by all columns and count duplicates
df.groupBy(df.columns).count().filter("count > 1").show()

# COMMAND ----------

# Remove duplicates
df = df.dropDuplicates()

# COMMAND ----------

# Convert and Extract Time Features
df = df \
    .withColumn("pickup_hour", hour("tpep_pickup_datetime")) \
    .withColumn("pickup_dayofweek", dayofweek("tpep_pickup_datetime")) \
    .withColumn("pickup_month", month("tpep_pickup_datetime"))

# COMMAND ----------

 # Create a Trip Duration Column:
 df = df.withColumn("trip_duration", 
    (unix_timestamp("tpep_dropoff_datetime") - unix_timestamp("tpep_pickup_datetime")) / 60)

# COMMAND ----------

# Check Invalid Data

invalid = df.filter(
    (col("trip_distance") <= 0) |
    (col("total_amount") <= 0) |
    (col("fare_amount") <= 0)
)

invalid.show()

# COMMAND ----------

df = df.filter(
    (col("trip_distance") > 0) &
    (col("total_amount") > 0) &
    (col("fare_amount") > 0)
)

# COMMAND ----------

# MAGIC %md
# MAGIC # 2. Exploratory Data Analysis (EDA)

# COMMAND ----------

# Descriptive Statistics
df.describe(["trip_distance", "fare_amount", "tip_amount", "total_amount"]).show()

# COMMAND ----------

# Correlation Analysis
# Select numeric columns for correlation
num_cols = ['trip_distance', 'fare_amount', 'tip_amount', 'tolls_amount', 'trip_duration', 'total_amount']
assembler = VectorAssembler(inputCols=num_cols, outputCol="features")
df_vec = assembler.transform(df).select("features")

# Compute correlation matrix
corr_matrix = Correlation.corr(df_vec, "features").head()[0]
print("Correlation Matrix:\n")
print(corr_matrix)

# COMMAND ----------

# Correlation Analysis
# Select numeric columns for correlation
num_cols = ['trip_distance', 'fare_amount', 'tip_amount', 'tolls_amount', 'trip_duration', 'total_amount']

assembler = VectorAssembler(inputCols=num_cols, outputCol="features")
df_vector = assembler.transform(df).select("features")
print(df_vector)
# Compute correlation matrix
correlation_matrix = Correlation.corr(df_vector, "features").head()[0].toArray()
print(correlation_matrix)

# COMMAND ----------

# Create a DataFrame for easier formatting
corr_df = pd.DataFrame(correlation_matrix, index=num_cols, columns=num_cols)
corr_df.reset_index(inplace=True)
corr_df = corr_df.melt(id_vars=["index"], var_name="feature", value_name="correlation")
corr_df.columns = ["feature_1", "feature_2", "correlation"]

# Convert to Spark DataFrame
correlation_spark_df = spark.createDataFrame(corr_df)
correlation_spark_df.show()

# COMMAND ----------



# COMMAND ----------

# MAGIC %md
# MAGIC - tip_amount vs total_amount: 0.99995. This is nearly a perfect correlation — expected, since tips are included in the total fare. Tipping behavior contributes significantly to total cost.
# MAGIC - fare_amount vs tolls_amount: 0.495 Moderate correlation, possibly due to tolls being common on longer or outer borough trips. Tolls tend to increase with base fare, often in fixed routes (e.g., airport trips).
# MAGIC - trip_distance has no significant correlation with any field — surprising, but likely due to inconsistent pricing.
# MAGIC - trip_duration has minimal correlation with all variables, suggesting duration isn’t a key factor in cost calculation for short city rides.

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1. Temporal Patterns – When is Taxi Demand Highest?

# COMMAND ----------

# Trip Volume by Hour
df.groupBy("pickup_hour").count().orderBy("pickup_hour").show()

# COMMAND ----------

# Trip Volume by Day of Week:
df.groupBy("pickup_dayofweek").count().orderBy("pickup_dayofweek").show()

# COMMAND ----------

# MAGIC %md
# MAGIC ### 2. Spatial Patterns – Which Zones Have Frequent Pickups/Drop-offs?

# COMMAND ----------

# Round Coordinates for Approximate Clustering:
df = df.withColumn("pickup_lat_round", round("pickup_latitude", 2)) \
       .withColumn("pickup_lon_round", round("pickup_longitude", 2)) \
       .withColumn("dropoff_lat_round", round("dropoff_latitude", 2)) \
       .withColumn("dropoff_lon_round", round("dropoff_longitude", 2))

# Frequent Pickup Coordinates:
df.groupBy("pickup_lat_round", "pickup_lon_round") \
  .count().orderBy("count", ascending=False).show(10)

# COMMAND ----------

# MAGIC %md
# MAGIC ### 3. Trip Duration & Congestion Patterns

# COMMAND ----------

# Avg Duration by Hour:
df.groupBy("pickup_hour").avg("trip_duration").orderBy("pickup_hour").show()

# Duration vs Distance
df.select("trip_distance", "trip_duration").describe().show()

# COMMAND ----------

#  Filter High Duration on Low Distance 
df.filter((col("trip_distance") < 1) & (col("trip_duration") > 15)).show(5)


# COMMAND ----------

# Taxi Trip Revenue and Tips Breakdown by Payment Type
df_with_payment_label = df.withColumn(
    "payment_label",
    when(col("payment_type") == 1, "Credit card")
    .when(col("payment_type") == 2, "Cash")
    .when(col("payment_type") == 3, "No charge")
    .when(col("payment_type") == 4, "Dispute")
    .when(col("payment_type") == 5, "Unknown")
    .when(col("payment_type") == 6, "Voided trip")
    .otherwise("Other")
)

df_with_payment_label.groupBy("payment_label") \
    .agg(avg("tip_amount").alias("avg_tip"), 
         avg("total_amount").alias("avg_total"),
         avg("fare_amount").alias("avg_fare")) \
    .orderBy("payment_label") \
    .show()

# COMMAND ----------

# MAGIC %md
# MAGIC # 3. Dashboard

# COMMAND ----------

spark.conf.set("spark.databricks.delta.schema.autoMerge.enabled", "true")
# Save DataFrame as a Table
df.write.format("delta").mode("overwrite").saveAsTable("taxi_data")

# COMMAND ----------

#  Save Correlation Table as SQL View
correlation_spark_df.write.mode("overwrite").saveAsTable("correlation_matrix_view")

# COMMAND ----------

df.show(5)

# COMMAND ----------

df.printSchema()