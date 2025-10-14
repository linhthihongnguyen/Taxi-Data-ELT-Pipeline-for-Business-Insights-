# Taxi-Data-ELT-Pipeline-for-Business-Insights

In metropolitan areas like **New York City**, taxis play a vital role in urban mobility. This project tackles the challenge of optimizing taxi transportation patterns through the development of an **ELT (Extract, Load, Transform) pipeline** for analyzing taxi data to provide valuable business insights utilizing PySparks and SQL on Databricks. The project consists of the following stages:

## 1. Data Extraction & Transformation:
- I imported raw data into **Databricks** and used **PySpark** to efficiently extract and clean the data.
- The process included handling missing values, duplicates, and performing feature engineering to create variables like:
  - **Trip duration**
  - **Pickup hour**
  - **Day of the week**
- This transformed data is now ready for analysis.

## 2. Data Loading into Delta Lake:
- After transforming the data, I stored it in **Delta Lake** to ensure data consistency and enable efficient querying.
- I used **PySpark** commands to save the data, making it accessible for further analysis.

## 3. SQL for Analysis & Reporting:
- Using **SQL** within **Databricks**, I analyzed the data directly from **Delta Lake** to generate actionable insights.
- Key analysis performed includes:
  - **Peak demand times**
  - **Spatial patterns** of frequently visited pickup locations
  - **Tip revenue breakdowns** by payment types
- I created aggregated metrics such as:
  - **Average fare**
  - **Total revenue**
- These insights were crucial for evaluating operational performance.

## 4. Dashboards:
- I built an **interactive dashboard** in **Databricks** to visualize insights extracted from SQL queries.
- The dashboard enabled stakeholders to make **data-driven decisions** such as:
  - Adjusting fleet management strategies.
  - Implementing surge pricing based on demand.
  
## Taxi Data
You can download the `yellow_tripdata_2015-01.zip` file from [Kaggle: NYC Yellow Taxi Trip Data](https://www.kaggle.com/datasets/elemento/nyc-yellow-taxi-trip-data).

> **Note**: This file is too large to be included directly in the GitHub repository.
