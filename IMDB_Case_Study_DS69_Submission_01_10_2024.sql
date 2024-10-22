USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:


SELECT COUNT(*) AS director_mapping_count FROM director_mapping dm; -- 3867

SELECT COUNT(*) AS genre_count FROM genre g; -- 14662

SELECT COUNT(*) AS movie_count FROM movie m; -- 7997 

SELECT COUNT(*) AS names_count FROM names n; -- 25735

SELECT COUNT(*) AS rating_count FROM ratings r; -- 7997

SELECT COUNT(*) AS role_mapping_count FROM role_mapping rm; -- 15615

  




-- Q2. Which columns in the movie table have null values?
-- Type your code below:


-- Query to identify columns in movie table which contain null values
SELECT null_col AS null_data_columns 
FROM
(
	SELECT DISTINCT CASE when country IS NULL THEN 'country'
			WHEN date_published IS NULL THEN 'date_published'
			WHEN duration IS NULL THEN 'duration'
			WHEN id IS NULL THEN 'id'
			WHEN languages IS NULL THEN 'languages'
			WHEN production_company IS NULL THEN 'production_company'
			WHEN production_company IS NULL THEN 'production_company'
			WHEN worlwide_gross_income IS NULL THEN 'worlwide_gross_income'
			WHEN year IS NULL THEN 'year'
		ELSE '' END null_col
	FROM movie m
) null_col_val_details
WHERE nullif(null_col,'') IS NOT NULL;





-- Now AS you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


-- Query to find the total number of movies released each year
SELECT 
	year, 
	COUNT(id) AS number_of_movies
FROM movie m
GROUP BY m.`year`
ORDER BY m.`year`;

-- Query to find the total number of movies released month wise
SELECT 
	MONTH(date_published) AS month_num, 
	COUNT(id) AS number_of_movies
FROM movie m
GROUP BY month_num
ORDER BY month_num;





/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


-- Movies were produced in the USA or India in the year 2019
SELECT 
	m.`year`, 
	COUNT(id) movie_released
FROM movie m
WHERE country IN ('USA', 'India') 
AND m.`year` = 2019;






/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


-- 13 unique genre present in data set.
SELECT DISTINCT genre
FROM genre g
ORDER BY genre;






/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


-- Drama has the highest number of movies produced
WITH genre_rank_summary AS(
	SELECT
		gnr.genre, 
		COUNT(mve.id) AS movie_count,
		ROW_NUMBER() OVER(ORDER BY COUNT(mve.id) DESC) AS genre_rank
	FROM genre gnr
	INNER JOIN movie mve ON gnr.movie_id = mve.id
	WHERE mve.year = (select MAX(year) from movie) -- 2019 is last year
	GROUP BY gnr.genre 
)
SELECT genre, movie_count
FROM genre_rank_summary
WHERE genre_rank = 1;






/* So, based ON the insight that you just drew, RSVP Movies should focus ON the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


SELECT 
	COUNT(movie_id) AS movie_count
FROM(
	SELECT 
		movie_id, 
		COUNT(genre) AS genre_count
     FROM genre
     GROUP BY movie_id
     ORDER BY genre_count DESC
 ) genre_counts
WHERE genre_count = 1
GROUP BY genre_count;

-- 3289 movies exactly have single genere







/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


-- Average duration of movies in each genre
SELECT 
	gnr.genre, 
	ROUND(AVG(mve.duration),2) AS avg_duration
FROM movie mve
INNER JOIN genre gnr ON mve.id = gnr.movie_id
GROUP BY gnr.genre
ORDER BY avg_duration DESC;






/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find WHERE the movies of genre 'thriller' ON the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Query to find out rank of thriller genre using CTE
WITH genere_summary AS
(
  SELECT 
	genre,
  	COUNT(movie_id) AS movie_count,
  RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genere_rank
  FROM genre
  GROUP BY genre
 )
SELECT *
FROM genere_summary
WHERE genre = 'Thriller';





/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table AS well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
-- Correction: Last column name is max_median_rating 

SELECT 
	MIN(avg_rating) AS min_avg_rating,
	MAX(avg_rating) AS max_avg_rating,
	MIN(total_votes) AS min_total_votes,
	MAX(total_votes) AS max_total_votes,
	MIN(median_rating) AS min_median_rating,
	MAX(median_rating) AS max_median_rating
FROM ratings r;





/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based ON average rating.*/

-- Q11. Which are the top 10 movies based ON average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too


WITH top_10_movie_avg_rating AS(
	SELECT 
		title,
		rtn.avg_rating,
		DENSE_RANK() OVER(ORDER BY rtn.avg_rating DESC) AS movie_rank
	FROM movie mve
	INNER JOIN ratings rtn ON mve.id = rtn.movie_id
)
SELECT title, avg_rating, movie_rank
FROM top_10_movie_avg_rating
WHERE movie_rank <= 10;




/* Do you find your favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be FROM these movies?
Summarising the ratings table based ON the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based ON the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- ORDER BY is good to have



SELECT
	rnt.median_rating, 
	COUNT(rnt.movie_id) AS movie_count
FROM ratings rnt
GROUP BY rnt.median_rating
ORDER BY rnt.median_rating;






/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT 
	mve.production_company,
	COUNT(mve.id) movie_count,
	DENSE_RANK() OVER(ORDER BY COUNT(mve.id) DESC) AS prod_company_rank
FROM movie mve 
INNER JOIN ratings rnt ON rnt.movie_id = mve.id
WHERE rnt.avg_rating > 8 
AND production_company IS NOT NULL
GROUP BY mve.production_company;







-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
	genre, 
	COUNT(mve.id) AS movie_count
FROM movie mve
INNER JOIN genre gnr ON mve.id = gnr.movie_id 
INNER JOIN ratings rnt ON mve.id = rnt.movie_id
WHERE mve.`year` = 2017 
AND MONTH(mve.date_published) = 3
AND mve.country = 'USA'
AND rnt.total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;






-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


SELECT 
	mve.title, 
	rnt.avg_rating, 
	gnr.genre 
FROM movie mve
INNER JOIN genre gnr ON mve.id = gnr.movie_id 
INNER JOIN ratings rnt ON mve.id = rnt.movie_id
WHERE mve.title like 'The%'
AND rnt.avg_rating > 8
ORDER BY rnt.avg_rating DESC;







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released BETWEEN 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


-- Number of movies released BETWEEN 1 April 2018 and 1 April 2019 and median rating of 8
SELECT
	COUNT(mve.id) AS movie_count 
FROM movie mve
INNER JOIN ratings rnt ON mve.id = rnt.movie_id
WHERE rnt.median_rating  = 8
AND mve.date_published BETWEEN '2018-04-01' AND '2019-04-01';






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


SELECT 
	mve.country, 
	SUM(rnt.total_votes) AS total_votes 
FROM movie mve
INNER JOIN ratings rnt ON mve.id = rnt.movie_id
WHERE mve.country in ('Germany','Italy')
GROUP BY mve.country;






-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT 
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
	SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
	SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
	SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names nm;






/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH genre_list AS(		-- get top 3 genre HAVING avg movie rating > 8
	SELECT 
		genre, 
		COUNT(gnr.movie_id) movie_count,
		DENSE_RANK() over (ORDER BY COUNT(gnr.movie_id) DESC) AS genre_rank
	FROM genre gnr 
	INNER JOIN ratings rnt ON rnt.movie_id = gnr.movie_id
	WHERE rnt.avg_rating > 8
	GROUP BY genre
),
top_director_list AS(	-- get top directos in top 3 genre HAVING avg movie rating > 8
	SELECT 
		dm.name_id, 
		COUNT(dm.movie_id) AS dir_movie_count,
		ROW_NUMBER() OVER(ORDER BY COUNT(dm.movie_id) DESC) dir_movie_rank
	FROM director_mapping dm 
	INNER JOIN genre g ON g.movie_id = dm.movie_id 
	INNER JOIN ratings r ON r.movie_id = dm.movie_id 
	WHERE g.genre in (SELECT genre FROM genre_list WHERE genre_rank <= 3)
	AND r.avg_rating > 8
	GROUP BY dm.name_id
	ORDER BY dir_movie_count DESC
)
SELECT 		-- top three directors in the top three genres whose movies have an average rating > 8
	n.name AS director_name, 
	dl.dir_movie_count AS movie_count
FROM names n
INNER JOIN top_director_list dl ON n.id = dl.name_id
WHERE dl.dir_movie_rank <= 3;





/* James Mangold can be hired AS the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top_actor_list AS(
	SELECT 
		rm.name_id, 
		COUNT(rm.movie_id) AS movie_count,
		ROW_NUMBER() OVER(ORDER BY COUNT(rm.movie_id) DESC) AS actor_rank
	FROM ratings r 
	INNER JOIN role_mapping rm ON rm.movie_id = r.movie_id
	INNER JOIN names n ON n.id = rm.name_id
	WHERE r.median_rating >= 8 
	AND rm.category = 'actor'
	GROUP BY name_id
)
SELECT nm.name, al.movie_count
FROM names nm
INNER JOIN top_actor_list al ON al.name_id = nm.id
WHERE al.actor_rank <= 2;






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based ON the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:



WITH top_production_company_list AS(
	SELECT 
		mv.production_company,
		SUM(rtn.total_votes) AS vote_count,
		DENSE_RANK() OVER(ORDER BY SUM(rtn.total_votes) DESC) AS prod_comp_rank
	FROM movie mv 
	INNER JOIN ratings rtn ON mv.id = rtn.movie_id
	WHERE mv.production_company IS NOT NULL
	GROUP BY production_company
)
SELECT * 
FROM top_production_company_list
WHERE prod_comp_rank <= 3;






/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based ON the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based ON their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based ON votes. If the ratings clash, THEN the total number of votes should act AS the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
	nm.name AS actor_name,
	SUM(rtn.total_votes) AS total_votes,
	COUNT(mv.id) AS movie_count,
	ROUND(SUM(rtn.avg_rating * rtn.total_votes) / SUM(rtn.total_votes), 2) AS actor_avg_rating,
	DENSE_RANK() OVER(ORDER BY ROUND(SUM(rtn.avg_rating * rtn.total_votes) / SUM(rtn.total_votes), 2) DESC) AS actor_rank
FROM movie mv 
INNER JOIN ratings rtn ON mv.id = rtn.movie_id
INNER JOIN role_mapping rm ON mv.id = rm.movie_id 
INNER JOIN names nm ON rm.name_id = nm.id
WHERE mv.country = 'India' 
AND rm.category = 'actor'
GROUP BY actor_name
HAVING movie_count >= 5;






-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based ON their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based ON votes. If the ratings clash, THEN the total number of votes should act AS the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
	nm.name AS actor_name,
	SUM(rtn.total_votes) AS total_votes,
	COUNT(mv.id) AS movie_count,
	ROUND(SUM(rtn.avg_rating * rtn.total_votes) / SUM(rtn.total_votes), 2) AS actor_avg_rating,
	DENSE_RANK() OVER(ORDER BY ROUND(SUM(rtn.avg_rating * rtn.total_votes) / SUM(rtn.total_votes), 2) DESC) AS actor_rank
FROM movie mv 
INNER JOIN ratings rtn ON mv.id = rtn.movie_id
INNER JOIN role_mapping rm ON mv.id = rm.movie_id 
INNER JOIN names nm ON rm.name_id = nm.id
WHERE mv.country = 'India' 
AND rm.category = 'actress' 
AND languages = 'Hindi'
GROUP BY actor_name
HAVING movie_count >= 3
LIMIT 5;






/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. SELECT thriller movies AS per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating BETWEEN 7 and 8: Hit movies
			Rating BETWEEN 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT 
	mv.title,
	CASE WHEN rtn.avg_rating > 8 THEN 'Superhit movies'
		 WHEN rtn.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
		 WHEN rtn.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
	 ELSE 'Flop movies' END AS rating_category
FROM movie mv
INNER JOIN genre gnr ON mv.id = gnr.movie_id
INNER JOIN ratings rtn ON mv.id = rtn.movie_id
WHERE gnr.genre = 'Thriller';






/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH avg_duration_summary AS(
	SELECT
		g.genre,
		ROUND(AVG(m.duration),2) AS avg_duration
	FROM movie m 
	INNER JOIN genre g ON m.id = g.movie_id
	GROUP BY g.genre
)
SELECT 
	genre,
	avg_duration,
	ROUND(SUM(avg_summ.avg_duration) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING),2) AS running_total_duration,
	ROUND(AVG(avg_summ.avg_duration) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING),2) AS moving_avg_duration
FROM avg_duration_summary AS avg_summ
GROUP BY genre;






-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based ON most number of movies


WITH top_genre_list AS(
	SELECT 
		g.genre, 
		COUNT(movie_id) AS movie_count,
		DENSE_RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS movie_rank 
	FROM genre g 
	GROUP BY genre
),
top_movie_list AS(
	SELECT 
		group_concat(g.genre separator ', ') genre,
		m.`year`,
		m.title AS movie_name,
		m.worlwide_gross_income,
		DENSE_RANK() OVER(PARTITION BY m.`year` ORDER BY m.worlwide_gross_income DESC) AS movie_iincome_rank
	FROM movie m 
	INNER JOIN genre g ON m.id = g.movie_id
	WHERE g.genre in (SELECT genre FROM top_genre_list gl WHERE gl.movie_rank <= 3)
	GROUP BY m.year, movie_name, worlwide_gross_income
)
SELECT *
FROM top_movie_list ml
WHERE ml.movie_iincome_rank <= 5;







-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT  
	production_company,
	COUNT(id) AS movie_count,
	DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
WHERE m.production_company IS NOT NULL
AND POSITION(',' IN m.languages) > 0
AND r.median_rating >= 8
GROUP BY production_company
LIMIT 2;








-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based ON number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
	n.name AS actress_name, 
	SUM(r.total_votes) AS total_votes,
	COUNT(rm.movie_id) AS movie_count,
	AVG(r.avg_rating) AS actress_avg_rating,
	DENSE_RANK() OVER(ORDER BY AVG(r.avg_rating) DESC) AS actress_rank
FROM role_mapping rm 
INNER JOIN genre g ON rm.movie_id = g.movie_id 
INNER JOIN ratings r ON r.movie_id = rm.movie_id 
INNER JOIN names n ON n.id = rm.name_id 
WHERE r.avg_rating > 8
AND g.genre = 'Drama'
AND rm.category = 'actress'
GROUP BY actress_name
LIMIT 3;







/* Q29. Get the following details for top 9 directors (based ON number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH director_movie_info AS(	-- get next published date
	SELECT 
		dm.name_id, 
		n.name,
		dm.movie_id,
		m.date_published,
		lead(m.date_published, 1) OVER(PARTITION BY dm.name_id ORDER BY m.date_published, dm.movie_id) AS next_date_published
	FROM director_mapping dm 
	INNER JOIN names n ON dm.name_id = n.id 
	INNER JOIN movie m ON dm.movie_id = m.id
), 
inter_movie_release_diff_data AS(	-- find date difference
	SELECT 
		name_id,
		name,
		movie_id,
		date_published,
		datediff(next_date_published, date_published) AS date_diff 
	FROM director_movie_info
),
avg_inter_movie_release_diff_data AS(	-- find average of date difference
	SELECT name_id, AVG(date_diff) AS avg_inter_movie_days
	FROM inter_movie_release_diff_data
	GROUP BY name_id
),
director_movie_summary AS(	-- retrive director information
	SELECT 
		dm.name_id,
		n.name,
		COUNT(dm.movie_id) AS number_of_movies,
		ROUND(avg_inter_movie_days) AS avg_inter_movie_days,
		ROUND(AVG(r.avg_rating),2) AS avg_rating,
		SUM(r.total_votes) AS total_votes,
		MIN(r.avg_rating) AS min_rating,
		MAX(r.avg_rating) AS max_rating,
		SUM(m.duration) AS total_duration,
		ROW_NUMBER() OVER(ORDER BY COUNT(dm.movie_id) DESC) AS movie_raak
	FROM director_mapping dm 
	INNER JOIN names n ON dm.name_id = n.id 
	INNER JOIN movie m ON dm.movie_id = m.id
	INNER JOIN ratings r ON r.movie_id = dm.movie_id
	INNER JOIN avg_inter_movie_release_diff_data avg_data ON avg_data.name_id = dm.name_id
	GROUP BY dm.name_id, n.name, avg_data.avg_inter_movie_days
)
SELECT
	name_id,
	name,
	number_of_movies,
	avg_inter_movie_days,
	avg_rating,
	total_votes,
	min_rating,
	max_rating,
	total_duration
FROM director_movie_summary
WHERE movie_raak < 10;
