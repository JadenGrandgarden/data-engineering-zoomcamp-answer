# Data Engineering Zoomcamp Solution

This repository contains my solutions to the [DataTalksClub Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main) course. The course provides a comprehensive introduction to data engineering concepts, tools, and best practices.

## About the Course
The Data Engineering Zoomcamp covers:
- Introduction to data engineering
- Setting up a data engineering environment
- Building data pipelines
- Working with various tools and platforms, including BigQuery, Airflow, Spark, and more
- Advanced topics such as orchestration, analytics engineering, and cloud data engineering

## Repository Structure

This repository is organized by week, following the course structure:

```
├── 01-docker-terraform
│   ├── Q1 # Question 1. Understanding docker first run
│   ├── Q2 # Question 2. Understanding Docker networking and docker-compose
│   ├── Q3 # Question 3. Trip Segmentation Count
│   ├── Q4 # Question 4. Longest trip for each day
│   ├── Q5 # Question 5. Three biggest pickup zones
│   ├── Q6 # Question 6. Largest tip
│   └── Q7 # Question 7. Terraform Workflow
├── week2_workflow_orchestration
│   ├── airflow_dags  # DAGs implemented in Airflow
│   └── notes.md      # Key learnings and challenges
├── week3_data_warehouse
│   ├── queries.sql   # SQL scripts for data modeling
│   ├── dbt_project   # DBT transformations
│   └── diagrams      # ER diagrams or flowcharts
├── week4_analytics_engineering
│   ├── dbt_models    # DBT models for analytics
│   └── tests         # Unit and integration tests
├── week5_batch_processing
│   ├── pyspark_jobs  # PySpark scripts for batch processing
│   └── data_samples  # Sample data used in processing
├── week6_stream_processing
│   ├── kafka_streams  # Kafka and Spark Streaming code
│   └── dashboards     # Dashboards built for streaming data
├── week7_project
│   ├── final_project  # End-to-end data engineering project
│   └── presentation   # Slides and documents
└── README.md  # This file
```

## Tools and Technologies Used
- **BigQuery**: Data warehousing and analytics
- **DBT**: Analytics engineering and transformation
- **Airflow**: Workflow orchestration
- **Kafka**: Stream processing
- **Spark**: Batch and streaming data processing
- **GCP**: Cloud platform for deployment and hosting

## How to Use This Repository
1. Clone the repository:
   ```bash
   git clone https://github.com/JadenGrandgarden/data-engineering-zoomcamp-answer.git
   ```

2. Navigate to a specific week to explore the solutions:
   ```bash
   cd 0x-xxx-xxx
   ```

3. Follow the instructions in the `README.md` files within each week's folder to run the solutions.


---

**Note**: This repository is a work in progress as I continue to complete the course. Suggestions and contributions are welcome!
