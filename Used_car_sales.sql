select *
From [SQL PROJECTS].[dbo].[used_car_data$]
WHERE YEAR is not null


--Top 10 car brands on sale

select company,
      count(*) as cars_count
	  
From [SQL PROJECTS].[dbo].[used_car_data$]
--where company is not null
group by company
ORDER by cars_count desc;




-- Top 5 car sales trends 1953-2021
SELECT year, company,
       count(*) as cars_count
	   
From [SQL PROJECTS].[dbo].[used_car_data$]
where year is not null
group by company, year
ORDER by year asc;


--Year wise recent (2017-2021) car sales

SELECT year, company,
       count(*) as cars_count
	   
From [SQL PROJECTS].[dbo].[used_car_data$]
 
where year  between 2017 and 2021
group by company, year
ORDER by year asc;



--average price of cars on sale by year

SELECT year, company, AVG(price_in_aed) as avg_price,
       count(*) as cars_count
	   
From [SQL PROJECTS].[dbo].[used_car_data$]
 
where year  between 2017 and 2021
group by  year, company
ORDER by avg_price desc;

-- based on body type

select  company,body_type, count(*) as cars_body_type
     

From [SQL PROJECTS].[dbo].[used_car_data$]
group by company,body_type
order by body_type;

-- Average price of cars
Select  company, AVG( price_in_aed) as avg_price         
     

From [SQL PROJECTS].[dbo].[used_car_data$]

group by company
order by avg_price desc;

--sales by year
Select  
        year,
		sum(price_in_aed) as total_price
From [SQL PROJECTS].[dbo].[used_car_data$]
group by year
order BY total_price asc;

-- avg sale price by no.of cylinder
Select  
        no_of_cylinders ,
		avg(price_in_aed) as avg_price
From [SQL PROJECTS].[dbo].[used_car_data$]
where no_of_cylinders is not null
group by no_of_cylinders
order BY avg_price asc;

--avg sale price by horse power

Select  
        horsepower ,
		avg(price_in_aed) as avg_price
From [SQL PROJECTS].[dbo].[used_car_data$]
--where no_of_cylinders is not null
group by horsepower
order BY avg_price asc;

--avg sale price by body type
Select  
        body_type ,
		avg(price_in_aed) as avg_price
From [SQL PROJECTS].[dbo].[used_car_data$]
--where no_of_cylinders is not null
group by body_type
order BY avg_price asc;


 --avg sale price by model


 Select  
        model ,
		avg(price_in_aed) as avg_price
From [SQL PROJECTS].[dbo].[used_car_data$]
--where no_of_cylinders is not null
group by model
order BY avg_price desc;

--avg sale price by color
Select  
        color,
		avg(price_in_aed) as avg_price
From [SQL PROJECTS].[dbo].[used_car_data$]
--where no_of_cylinders is not null
group by color
order BY avg_price desc;

-- avg price by year and type of car
Select  
        year,
		avg(price_in_aed) as avg_price,
		count(company) as type_of_car
From [SQL PROJECTS].[dbo].[used_car_data$]
where year is not null
group by year
order BY avg_price desc;


-- avg sale price by km

SELECT company,
       avg(kilometers) as avg_km,
       avg(price_in_aed) as avg_price,
	   year
From [SQL PROJECTS].[dbo].[used_car_data$]
group by company,year
order by  year asc;

-- car prices based on company , model,horsepower

SELECT company,
       model,
	   horsepower,
       avg(price_in_aed) as avg_price
From [SQL PROJECTS].[dbo].[used_car_data$]
group by company, model,horsepower
order by avg_price;

-- car price based on fueltype 2017-2021

select fuel_type,
       avg(price_in_aed) as avg_price
From [SQL PROJECTS].[dbo].[used_car_data$]
where year between 2017 and 2021
group by fuel_type
order by avg_price;

--- before 2017

select fuel_type,
       avg(price_in_aed) as avg_price
From [SQL PROJECTS].[dbo].[used_car_data$]
where year < 2017 
group by fuel_type
order by avg_price;


-- car price of electric cars

SELECt company, 
       fuel_type,
	   avg(price_in_aed) as avg_price
From [SQL PROJECTS].[dbo].[used_car_data$]
--where year is not null and
 where fuel_type = 'Electric' 
 --company = 'Tesla'
group by fuel_type,company
order by avg_price asc;