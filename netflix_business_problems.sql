CREATE DATABASE netflix_db;

CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT * FROM netflix;

-- 1. Count the number of Movies vs TV Shows
SELECT * FROM netflix;

SELECT
type,
COUNT(*) FROM netflix
GROUP BY 1;

-- 2. Find the most common rating for movies and TV shows
SELECT * FROM netflix;

SELECT
type,
rating,
COUNT(*) AS count_rating
FROM netflix
GROUP BY type, rating
ORDER BY count_rating DESC;

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT * FROM netflix;

SELECT * 
FROM netflix
WHERE release_year = 2020

-- 4. Find the top 5 countries with the most content on Netflix
SELECT * FROM netflix;

SELECT
    country,
    COUNT(*) AS total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;

-- 5. Identify the longest movie
SELECT * FROM netflix;

SELECT
    title,
    director,
    country,
    release_year,
    duration
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(REPLACE(duration, ' min', '') AS INT) DESC

-- New method --

SELECT 
	*
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC

-- 6. Find content added in the last 5 years
SELECT * FROM netflix;

SELECT
    title,
    type,
    country,
    date_added,
    release_year
FROM netflix
WHERE date_added >= CURRENT_DATE - INTERVAL '5 years'
ORDER BY date_added DESC;

-- New method --

SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * FROM netflix;

SELECT
    title,
    type,
    director,
    country,
    release_year,
    rating,
    duration
FROM netflix
WHERE director = 'Rajiv Chilaka'
ORDER BY release_year DESC;

-- 8. List all TV shows with more than 5 seasons
SELECT * FROM netflix;

SELECT *
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5

-- 9. Count the number of content items in each genre
SELECT * FROM netflix;

SELECT
    listed_in AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY listed_in
ORDER BY total_content DESC;

-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!
SELECT * FROM netflix;

SELECT 
    release_year,
    COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY release_year
ORDER BY total_content DESC
LIMIT 5;


-- 11. List all movies that are documentaries
SELECT * FROM netflix;

SELECT
    title,
    director,
    country,
    release_year
FROM netflix
WHERE type = 'Movie'
AND listed_in ILIKE '%Documentaries%'
ORDER BY release_year DESC;

-- 12. Find all content without a director
SELECT * FROM netflix;
 
SELECT
    title,
    type,
    release_year
FROM netflix
WHERE director IS NULL
OR director = '';

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * FROM netflix;

SELECT * FROM netflix
WHERE 
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- New method --

SELECT
    COUNT(*) AS total_movies
FROM netflix
WHERE type = 'Movie'
AND cast ILIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT * FROM netflix;

SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- New method --

SELECT
    TRIM(actor) AS actor_name,
    COUNT(*) AS total_movies
FROM netflix,
LATERAL (UNNEST(STRING_TO_ARRAY(cast, ',')) AS actor
WHERE type = 'Movie'
AND country ILIKE '%India%'
GROUP BY actor_name
ORDER BY total_movies DESC
LIMIT 10;

15. -- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
SELECT * FROM netflix;

SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2

-- New method --

SELECT
    CASE
        WHEN description ILIKE '%kill%'
          OR description ILIKE '%violence%'
        THEN 'Bad'
        ELSE 'Good'
    END AS content_category,
    COUNT(*) AS total_content
FROM netflix
GROUP BY content_category
ORDER BY total_content DESC;

