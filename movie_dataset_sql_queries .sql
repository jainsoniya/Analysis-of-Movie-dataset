-- Create Database
CREATE DATABASE "Movie"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
;

-- Create Table
CREATE TABLE movies (
	id INTEGER PRIMARY KEY UNIQUE NOT NULL,
	imdb_id VARCHAR(50), 
	popularity FLOAT(50),
	budget INTEGER, 
	revenue INTEGER,
	original_title VARCHAR (300), 
	casts VARCHAR (300),
	homepage VARCHAR (300),
	director VARCHAR (300),
	tagline VARCHAR (300),
	keywords VARCHAR (300),
	overview VARCHAR (300),
	runtime INTEGER,
	genres VARCHAR (300),
	production_companies VARCHAR (300),
	release_date VARCHAR (50),
	vote_count INTEGER,
	vote_average FLOAT (50),
	release_year INTEGER,
	budget_adj FLOAT (50), 
	revenue_adj FLOAT (50)	
);

--Import csv file
COPY movies (id, imdb_id, popularity, budget, revenue, original_title, casts,homepage, director, tagline, keywords, overview,
	     runtime, genres, production_companies, release_date, vote_count, vote_average, release_year, budget_adj, revenue_adj) 
FROM 'C:\Temp\imdb-movies1.csv' DELIMITER ',' CSV HEADER;

---Research Question 1-Rank Production Companies based on their average profits earned from 1960 to 2015.

--Create temp table, unstack production companies onto next rows and calculate profits
WITH production_co_profits
AS
(
	SELECT id, unnest(string_to_array(production_companies, '|')) AS production_co, 
		 (revenue - budget) AS total_profits		
	FROM movies	
	WHERE budget != 0 AND revenue != 0 
	GROUP BY id, production_co
),
			  
--Create another temp table and count Production Companies for each movie
production_co_count
AS
(
	SELECT id, count(production_co) as production_count
	FROM production_co_profits
	GROUP BY id
),

--Create another temp table and calculate average profits for each production companies
production_avg_profits
AS
(
	SELECT production_co_profits.production_co,
		round(avg(production_co_profits.total_profits / production_co_count.production_count),0) AS avg_profits
	FROM production_co_profits
	JOIN production_co_count
	ON production_co_profits.id = production_co_count.id
	GROUP BY production_co
)
			  
/*
Check percentiles and quartiles to create bins 
SELECT 
	percentile_cont(.25) WITHIN GROUP (ORDER BY avg_profits) as one_forth_quartile, -- Answer: - 425,000
	percentile_cont(.50) WITHIN GROUP (ORDER BY avg_profits) as half_quartile, -- Answer: 4,343,559
	percentile_cont(.75) WITHIN GROUP (ORDER BY avg_profits) as three_forth_quartile,  -- Answer: 16,488,734
	percentile_cont(1) WITHIN GROUP (ORDER BY avg_profits) as one_percentile  -- Answer: 622,726,075
FROM production_avg_profits
;
*/
			  
/*Create bins based on percentiles and quartiles (rounded off)for profit range and rank the Production Companies based
on highest average profits.*/
SELECT production_co, avg_profits,
CASE
	WHEN avg_profits <=0 THEN 'losses' 
	WHEN avg_profits >0 AND avg_profits <= 4000000 THEN 'Marginal profits'
	WHEN avg_profits >4000000 AND avg_profits <= 17000000 THEN 'Good profits'
	WHEN avg_profits > 17000000 AND avg_profits < 623000000 THEN 'excellant profits' END AS profit_range,
DENSE_RANK() OVER (ORDER BY avg_profits DESC) AS rank
FROM production_avg_profits
ORDER BY avg_profits desc;

-- Research Question 2- Count Number of movies produced under each genre over years.

--Unstack genres and count movie ids.
SELECT release_year, genre, count(id) as movie_count
FROM 
(
	SELECT id, original_title, release_year, unnest(string_to_array(genres, '|')) AS genre, popularity, vote_count, vote_average
	FROM Movies
	WHERE genres is not null
) AS tb1
GROUP BY release_year, genre
ORDER BY release_year, genre;
