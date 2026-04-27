# Taxi Data ELT Pipeline for Business Insights

In metropolitan areas like **New York City**, taxis play a vital role in urban mobility. This project tackles the challenge of optimizing taxi transportation patterns through the development of an **ELT (Extract, Load, Transform) pipeline** for analyzing taxi data to provide valuable business insights utilizing PySpark and SQL on Databricks.

---

## Tech Stack

- **PySpark** — data extraction, cleaning, and feature engineering
- **Databricks** — cloud-based notebook environment and job scheduling
- **Delta Lake** — structured data storage and efficient querying
- **SQL** — analytical queries and reporting
- **Databricks Dashboards** — interactive business intelligence visualization

---

## Project Stages

### 1. Data Extraction & Transformation
- Imported raw CSV data into **Databricks** and used **PySpark** to extract and clean the data.
- Handled missing values, removed duplicates, and filtered invalid records (zero or negative fares/distances).
- Performed feature engineering to create:
  - **Trip duration** (in minutes)
  - **Pickup hour** and **day of the week**
  - **Rounded coordinates** for spatial grouping

### 2. Data Loading into Delta Lake
- Stored transformed data in **Delta Lake** to ensure data consistency and enable efficient querying.
- Saved correlation analysis results as a queryable Delta table.

### 3. SQL for Analysis & Reporting
- Analyzed data directly from Delta Lake using **SQL within Databricks**.
- Key analyses performed:
  - Peak demand times by hour and day
  - Spatial patterns of frequently visited pickup locations
  - Tip and revenue breakdowns by payment type
  - Average fare, total revenue, and trip duration metrics

### 4. Pipeline Scheduling
- The notebook is configured as a **Databricks Job** scheduled to run monthly, simulating a production ELT pipeline triggered by new data arrivals.

### 5. Dashboards
- Built an **interactive dashboard** in Databricks to visualize insights from SQL queries.
- Enabled stakeholders to make data-driven decisions around fleet management and pricing strategy.

---

## Key Findings

| Area | Insight |
|---|---|
|  Peak Hours | Highest trip volume occurs **5–8 PM**, with the longest average durations around **3 PM**, indicating traffic delays |
|  Busiest Days | **Saturday and Friday** have the highest trip volumes across the week |
|  Congestion | **Midtown Manhattan** shows many short trips with long durations, signaling heavy traffic congestion |
|  Payment & Tips | **Credit card** trips have significantly higher tips and fares; **cash** trips have minimal to no tipping |
|  Fare Correlation | Fare amount is weakly correlated with distance or duration — likely due to zone-based or fixed fares on key NYC routes |
|  Duration Patterns | Traffic and delays cause inconsistent trip durations, decoupling them from both fare and distance |

---

## Recommendations

- **Dispatching**: Avoid sending drivers to Midtown during peak hours; suggest alternate pickup zones nearby.
- **Pricing**: Implement congestion-based surcharges to manage demand during high-traffic periods.
- **Payments**: Promote cashless payments to increase tip revenue and reduce payment disputes.
- **Customer Experience**: Focus on payment method and rider experience to positively influence tipping behavior.
- **Dynamic Pricing**: Consider pricing strategies that factor in time-of-day and traffic conditions, not just distance.

---

## Conclusion

This project demonstrates how big data and scalable analytics platforms can uncover actionable insights in urban transportation systems. The temporal and spatial patterns derived from this analysis can directly support decisions in traffic management, taxi dispatching, and fare optimization.

Future work may expand this project with **real-time data streams** or **predictive modeling** to forecast demand and optimize resource allocation.

---

## Data Source

Download `yellow_tripdata_2015-01.zip` from [Kaggle: NYC Yellow Taxi Trip Data](https://www.kaggle.com/datasets/elemento/nyc-yellow-taxi-trip-data).

> **Note**: The dataset is too large to be included directly in the repository.
