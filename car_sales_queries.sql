SELECT
  *
FROM
  "BRIGHTCARS"."PUBLIC"."SALES"
LIMIT
  10;

----------Inspecting the data---------

  --1. Checking for null values in each column 
  SELECT
  *
FROM
  "BRIGHTCARS"."PUBLIC"."SALES"
WHERE year IS NULL;
-- Year column has zero null values

SELECT
  *
FROM
  "BRIGHTCARS"."PUBLIC"."SALES"
WHERE make IS NULL;
---null values present 
SELECT
  *
FROM
  "BRIGHTCARS"."PUBLIC"."SALES"
WHERE model IS NULL;
---null values present
SELECT
  *
FROM
  "BRIGHTCARS"."PUBLIC"."SALES"
WHERE body IS NULL;
---null values present 
SELECT
  *
FROM
  "BRIGHTCARS"."PUBLIC"."SALES"
WHERE transmission IS NULL;
--- null values present 
SELECT
  *
FROM
  "BRIGHTCARS"."PUBLIC"."SALES"
WHERE state IS NULL;
---no null values 
SELECT
  *
FROM
  "BRIGHTCARS"."PUBLIC"."SALES"
WHERE condition IS NULL;
---null values present 
SELECT
  *
FROM
  "BRIGHTCARS"."PUBLIC"."SALES"
WHERE odometer IS NULL;
---null values present
SELECT
  *
FROM
  "BRIGHTCARS"."PUBLIC"."SALES"
WHERE year IS NULL;
--no null vaule
SELECT
  *
FROM
  "BRIGHTCARS"."PUBLIC"."SALES"
WHERE sellingprice IS NULL;
---null values present
 SELECT
  *
FROM
  "BRIGHTCARS"."PUBLIC"."SALES"
WHERE saledate IS NULL;
---nulls available

-------------------------------------------------------------------------------------------------------
 
SELECT

--1. Changing the date and time to timestamp
    COALESCE(
        TRY_TO_TIMESTAMP(SALEDATE, 'MM/DD/YYYY HH24:MI:SS'),  -- Format 1
        TRY_TO_TIMESTAMP(SALEDATE, 'DY MON DD YYYY HH24:MI:SS'),  -- Format 2
        TRY_TO_TIMESTAMP(SALEDATE, 'YYYY-MM-DD HH24:MI:SS')  -- Format 3 (optional)
    ) AS sale_timestamp,

--2. Extracting the month name from the timestamp

    MONTHNAME(
        COALESCE(
            TRY_TO_TIMESTAMP(SALEDATE, 'MM/DD/YYYY HH24:MI:SS'),
            TRY_TO_TIMESTAMP(SALEDATE, 'DY MON DD YYYY HH24:MI:SS'),
            TRY_TO_TIMESTAMP(SALEDATE, 'YYYY-MM-DD HH24:MI:SS')
        )
    ) AS MONTHNAME, 

--3. Handling null values


  IFNULL (sale_timestamp, '0') AS purchase_date,
  year,mmr,state,
  IFNULL (make, 'Unknown') AS make, 
  IFNULL (model, 'Unknown') AS model,
  IFNULL (body, 'Unknown') AS body,
  IFNULL (condition, '-999') AS condition,
  IFNULL (transmission, 'Unknown') AS transmission, sellingprice, odometer,
 
--4. Categorising the mileage
    CASE WHEN odometer BETWEEN 1 AND 50000 THEN 'Low mileage'
         WHEN odometer BETWEEN 50001 AND 150000 THEN 'Average mileage'
         WHEN odometer BETWEEN 150001 AND 300000 THEN 'High mileage'
         WHEN odometer >300000 THEN 'Very high mileage'
         ELSE 'Unknown'
         END AS mileage_categories,
  

--5. Quantitative data
SUM(SELLINGPRICE) AS total_revenue,
SUM(sellingprice - mmr) AS profit,
(profit/total_revenue * 100) AS profit_margin,

--6. Creating Profit Margin Categories

 CASE  WHEN profit_margin <5 THEN 'Low Margin'
       WHEN profit_margin BETWEEN 6 AND 15 THEN 'Medium Margin'
    ELSE 'High margin'
       END AS profit_margin_categories,

FROM "BRIGHTCARS"."PUBLIC"."SALES"
GROUP BY ALL;

