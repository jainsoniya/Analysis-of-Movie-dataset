I am going to analyze the Imdb Movie dataset. This dataset includes various variables which I grouped into following buckets:
1.	Individual variables: Title, Genre and Production Company
2.	Income variables- Budget and Revenue
3.	Popularity variables- Populartiy, Vote_count and Vote_average
4.	Year variables - Release Year and Release Date
5.	Other variables- Cast and Director columns

I come from Finance background and hence out of natural curiosity, the following question came up in my mind when I quickly glanced through the dataset.
1.	What is the profit trend of the film industry as a whole?
2.	Number of production companies falling into different profit range.

It will also be fun to play with genres and its popularity and try to answer below questions.
1.	Which genre is most popular?
2.	Number of movies produced by each genre over the period of time.

I did my analysis in following pattern:
1.	Used SQL to extract, transform and load data into csv file.
2.	Connected csv file to Tableau to perform visual analysis.

You can see my analysis in [movie_datset_sql_queries.sql](https://github.com/jainsoniya/Analysis-of-Movie-dataset/blob/master/movie_dataset_sql_queries%20.sql) and [movie_dataset](https://github.com/jainsoniya/Analysis-of-Movie-dataset/blob/master/movie%20dataset.twbx) or [tableau public link](https://public.tableau.com/profile/soniya4758#!/vizhome/moviedataset_15880189447430/Story1) 

I also repeated the above process in Python (wrangling, exploratory data analysis and visual communications). Please refer [analysis_of_movie_dataset_using_python.ipynb](https://github.com/jainsoniya/Analysis-of-Movie-dataset/blob/master/analysis_of_movie_dataset_using_python.ipynb) file to see my analysis in Python.


