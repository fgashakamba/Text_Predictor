# Text Prediction Application

## Overview
The code in this repository implements a shiny app that leverages a text prediction model that was built as part of the final project of the JHU Data Science Specialization.

## Purpose of this application

This application provides an interface to:
- Write a sintence
- See the next word predicted by the underlying model
- See up to 5 other top possibilities

## Underlying Algorithm

- An N-gram model was built using the "Stupid Backoff" algorithm ([Brants et al 2007](http://www.cs.columbia.edu/~smaskey/CS6998-0412/supportmaterial/langmodel_mapreduce.pdf))
- The algorithm checks if highest-order (in this case, n=4) n-gram has been seen. If not "degrades" to a lower-order model (n=3, 2).

## Key features of the app

- The underlying code stores the n-gram and and their associated frequency tables in an SQLite database. This promotes scalability and makes the app fast. - The N-gram queries use SQL which is optimized for this type of table retrieval
- The "Stupid Backoff" algorithm that was used has a performance that rivals that of more sophisticated models such as Kneser-Ney.

## Further improvements recommended

- When forming the corpus, we only used 1% of the data provided in order to fit into the 100mb limit for free-account at ([Shiny Apps IO](https://shinyapps.io/)). If such constraints are removed, using a bigger training dataset would yield a better model.
- We believe that using PostgreSQL instead of SQLite would be preferred for scalability purposes.
- The current model discards contextual information past 4-grams. We could incorporate even higher level Ngrams in the future.
- The user interface uses only basic CSS and no further effort was made to improve the UI beyond what Shiny provides by default. Future work in this direction is highly recommended.
