<!-- WRITE-UP -->
# Docker-Terraform

## Exercise Instructions

In this exercise, you will learn to set up and utilize Docker and Terraform for data engineering tasks. Follow the steps outlined below to complete the exercise:

1. **Understanding docker first run**: 
    Refer to the [Docker First Run Documentation](https://docs.docker.com/get-started/#run-your-image-as-a-container) for detailed instructions on how to run your first Docker container.
2. **Understanding Docker networking and docker-compose**: 
    Refer to the [Docker Networking and Docker Compose Documentation](https://docs.docker.com/compose/networking/) for detailed instructions on how to set up networking and use docker-compose.
3. **Trip Segmentation Count**: 
    Refer to the following SQL code to count the number of trips that happened during the period of October 1st, 2019 (inclusive) and November 1st, 2019 (exclusive):
    ```sql
    SELECT 
        SUM(CASE WHEN trip_distance <= 1 THEN 1 ELSE 0 END) AS up_to_1_mile,
        SUM(CASE WHEN trip_distance > 1 AND trip_distance <= 3 THEN 1 ELSE 0 END) AS between_1_and_3_miles,
        SUM(CASE WHEN trip_distance > 3 AND trip_distance <= 7 THEN 1 ELSE 0 END) AS between_3_and_7_miles,
        SUM(CASE WHEN trip_distance > 7 AND trip_distance <= 10 THEN 1 ELSE 0 END) AS between_7_and_10_miles,
        SUM(CASE WHEN trip_distance > 10 THEN 1 ELSE 0 END) AS over_10_miles
    FROM 
        green_taxi_trips
    ```
4. **Longest trip for each day**: 
    Refer to the following SQL code to find the longest trip for each day based on the pickup time:
    ```sql
    SELECT 
        TO_CHAR(lpep_pickup_datetime::timestamp, 'YYYY-MM-DD') AS longest_pickup_datelpep_pickup_datetime
    FROM 
        green_taxi_trips
    WHERE 
        trip_distance = (SELECT MAX(trip_distance) FROM green_taxi_trips)
    ```
5. **Three biggest pickup zones**: 
    Refer to the following SQL code to find the three biggest pickup zones based on the number of trips:
    ```sql
    Select 
        "Zone" 
    From 
        zone_table
    where 
        "LocationID" 
    in 
    (
        select 
            "PULocationID"
        from 
            green_taxi_trips
        where 
            lpep_pickup_datetime::date = '2019-10-18'
        group by 
            "PULocationID"
        having 
            SUM("total_amount") > 13000
    );
    ```
6. **Largest tip**: 
    Refer to the following SQL code to find the drop-off zone that had the largest tip for passengers picked up in October 2019 in the zone named "East Harlem North":
    ```sql
    SELECT "Zone"
    FROM zone_table
    WHERE "LocationID" = (
        SELECT "DOLocationID"
        FROM (
            SELECT "DOLocationID", tip_amount
            FROM green_taxi_trips
            WHERE "PULocationID" = (
                SELECT "LocationID" 
                FROM zone_table 
                WHERE "Zone" = 'East Harlem North'
            )
            ORDER BY tip_amount DESC
            LIMIT 1
        ) AS filtered_trips
    );
    ```
7. **Terraform Workflow**
    ```sh
    # Refresh service-account's auth-token for this session
    gcloud auth application-default login

    # Initialize state file (.tfstate)
    terraform init
    ```

    ```sh
    # Checking automatically changes to new infra plan and create new infra
    terraform apply -auto-approve
    ```
    ```sh
    # Delete infra after your work, to avoid costs on any running services
    terraform destroy
    ```

## Additional Resources

For more information and resources, refer to the [Data Engineering Zoomcamp GitHub Repository](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main).