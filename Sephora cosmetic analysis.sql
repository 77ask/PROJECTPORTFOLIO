/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [product_id]
      ,[product_name]
      ,[brand_id]
      ,[brand_name]
      ,[loves_count]
      ,[rating]
      ,[reviews]
      ,[size]
      ,[variation_type]
      ,[variation_value]
      ,[variation_desc]
      ,[ingredients]
      ,[price_usd]
      ,[value_price_usd]
      ,[sale_price_usd]
      ,[limited_edition]
      ,[new]
      ,[online_only]
      ,[out_of_stock]
      ,[sephora_exclusive]
      ,[highlights]
      ,[primary_category]
      ,[secondary_category]
      ,[tertiary_category]
      ,[child_count]
      ,[child_max_price]
      ,[child_min_price]
  FROM [SQL PROJECTS].[dbo].[product_info$]
  WHERE rating is  not null
 
  --now 8216 rows

  --number of brands --304
  
SELECT COUNT(DISTINCT product_name) AS product_count,brand_name
FROM [SQL PROJECTS].[dbo].[product_info$]
GROUP by brand_name

--Top 10 favourite products
SELECT Top 10 product_name,loves_count
FROM [SQL PROJECTS].[dbo].[product_info$]
ORDER BY loves_count DESC

--What is the average rating?
SELECT avg( rating) as Avg_rating
FROM [SQL PROJECTS].[dbo].[product_info$]

 --avg rating is 4.19

 --classification of rating Method 1
 SELECT product_id, product_name,
       AVG(rating) AS avg_rating,
       CASE
           WHEN AVG(rating) >= 4.5 THEN 'Excellent'
           WHEN AVG(rating) >= 3.5 THEN 'Good'
           WHEN AVG(rating) >= 2.5 THEN 'Fair'
           WHEN AVG(rating) >= 1.5 THEN 'Poor'
           ELSE 'Very Poor'
       END AS rating_classification
FROM [SQL PROJECTS].[dbo].[product_info$]
GROUP BY product_id;

--classification of rating -method 2 -with sub query

select rating_classification,
count(*) as Count
FROM(
SELECT 
    product_id,
    product_name,
    rating,
    CASE
        WHEN rating >= 4 THEN 'Good'
        WHEN rating >= 3 AND rating < 4 THEN 'Average'
        ELSE 'Poor'
    END AS rating_classification
FROM [SQL PROJECTS].[dbo].[product_info$]
) t
GROUP BY rating_classification

--reviews
--What is the average rating and number of reviews for each product category (primary, secondary, tertiary)?
SELECT 
  primary_category, 
  secondary_category, 
  tertiary_category , 
  AVG(rating) AS avg_rating, 
  COUNT(reviews) AS review_count
FROM [SQL PROJECTS].[dbo].[product_info$]
  
GROUP BY 
  primary_category, 
  secondary_category, 
  tertiary_category
ORDER BY review_count DESC

--
SELECT 
  COALESCE(primary_category, 'N/A') AS primary_category, 
  COALESCE(secondary_category, 'N/A') AS secondary_category, 
  COALESCE(tertiary_category, 'N/A') AS tertiary_category, 
  AVG(rating) AS avg_rating, 
  COUNT(reviews) AS review_count
FROM [SQL PROJECTS].[dbo].[product_info$]
  
GROUP BY 
  COALESCE(primary_category, 'N/A'), 
  COALESCE(secondary_category, 'N/A'), 
  COALESCE(tertiary_category, 'N/A')
ORDER BY 
  primary_category, 
  secondary_category, 
  tertiary_category;

==What is the distribution of product prices, and how does this vary by brand or category?

  SELECT 
  brand_name, 
  primary_category, 
  secondary_category, 
  tertiary_category, 
  COUNT(*) AS product_count, 
  MIN(price_usd) AS min_price, 
  MAX(price_usd) AS max_price, 
  AVG(price_usd) AS avg_price
FROM 
  [SQL PROJECTS].[dbo].[product_info$]
GROUP BY 
  brand_name, 
  primary_category, 
  secondary_category, 
  tertiary_category
ORDER BY 
  primary_category, 
  secondary_category, 
  tertiary_category;

--Is there a relationship between a product's loves count and its rating or price?
SELECT
  CASE 
    WHEN loves_count < 100 THEN '<100'
    WHEN loves_count >= 100 AND loves_count < 1000 THEN '100-999'
    WHEN loves_count >= 1000 AND loves_count < 10000 THEN '1,000-9,999'
    ELSE '>=10,000'
  END AS loves_count_range,
  AVG(rating) AS avg_rating,
  AVG(price_usd) AS avg_price
FROM [SQL PROJECTS].[dbo].[product_info$]
GROUP BY 
  CASE 
    WHEN loves_count < 100 THEN '<100'
    WHEN loves_count >= 100 AND loves_count < 1000 THEN '100-999'
    WHEN loves_count >= 1000 AND loves_count < 10000 THEN '1,000-9,999'
    ELSE '>=10,000'
  END
ORDER BY loves_count_range

--Which brands have the most products with limited edition or online-only status, 
  --and do these products have higher average prices or ratings?
SELECT 
  brand_name,
  SUM(CASE WHEN limited_edition = 1 THEN 1 ELSE 0 END) AS limited_edition_count,
  SUM(CASE WHEN online_only = 1 THEN 1 ELSE 0 END) AS online_only_count,
  AVG(price_usd) AS avg_price,
  AVG(rating) AS avg_rating
FROM [SQL PROJECTS].[dbo].[product_info$]
GROUP BY brand_name
ORDER BY limited_edition_count DESC, online_only_count DESC

--How do product ingredients vary by category, brand, or price point?

SELECT 
  primary_category, 
  secondary_category, 
  tertiary_category, 
  brand_name, 
  price_usd, 
  ingredients 
FROM [SQL PROJECTS].[dbo].[product_info$]
WHERE ingredients IS NOT NULL
ORDER BY  price_usd DESC  --primary_category, secondary_category, tertiary_category, brand_name,) price_usd DESC


--Are there any correlations between a product's variation type or value and its price,
--rating, or popularity?

SELECT 
  variation_type, 
  variation_value, 
  AVG(price_usd) AS avg_price, 
  AVG(rating) AS avg_rating, 
  AVG(loves_count) AS avg_loves_count
FROM [SQL PROJECTS].[dbo].[product_info$]
WHERE variation_type is NOT NULL and variation_value is NOT NULL
GROUP BY variation_type, variation_value
--ORDER BY variation_type, variation_value
ORDER BY  avg_loves_count DESC


--What are the most common highlights (features or benefits) mentioned in product descriptions or reviews, 
--and how do these vary by category or brand? 
SELECT 
  highlights, 
  primary_category, 
  brand_name, 
  COUNT(*) AS highlight_count
FROM [SQL PROJECTS].[dbo].[product_info$]
WHERE highlights is NOT NULL
GROUP BY highlights, primary_category, brand_name
ORDER BY highlight_count DESC

--How do sales, out of stock status, and new arrivals affect product ratings or loves counts?

SELECT 
  AVG(rating) AS avg_rating, 
  AVG(loves_count) AS avg_loves_count, 
  SUM(CASE WHEN sale_price_usd IS NOT NULL THEN 1 ELSE 0 END) AS num_on_sale, 
  SUM(CASE WHEN out_of_stock = 1 THEN 1 ELSE 0 END) AS num_out_of_stock, 
  SUM(CASE WHEN new = 1 THEN 1 ELSE 0 END) AS num_new_arrivals
FROM [SQL PROJECTS].[dbo].[product_info$]

--Are there any brands that consistently receive high ratings or loves counts across their products, 
--and what are the key features of these products?

SELECT 
    brand_name, 
    AVG(rating) AS avg_rating,
    SUM(loves_count) AS total_loves
FROM [SQL PROJECTS].[dbo].[product_info$]
    
GROUP BY 
    brand_name
HAVING 
    AVG(rating) >= 4.5 AND SUM(loves_count) >= 1000
ORDER BY 
    AVG(rating) DESC, 
    SUM(loves_count) DESC;
