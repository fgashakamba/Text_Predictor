# Process document into SQLite Database
library(tm)
library(RSQLite)
source('utility.R')

# Reading in data
blogs_lines <- readLines("data/en_US.blogs.txt", warn = FALSE, encoding = "UTF-8")
news_lines <- readLines("data/en_US.news.txt", warn = FALSE, encoding = "UTF-8")
twitter_lines <- readLines("data/en_US.twitter.txt", warn = FALSE, encoding = "UTF-8")

# Sanitize the data
set.seed(65432)
blogs_sanit <-iconv(blogs_lines,"latin1","ASCII",sub="")
news_sanit <-iconv(news_lines,"latin1","ASCII",sub="")
twitter_sanit <-iconv(twitter_lines,"latin1","ASCII",sub="")

# sample data set only 1% of each file
blogs <- sample(blogs_sanit,length(blogs_sanit)*0.01)
news <- sample(news_sanit,length(news_sanit)*0.01)
twitter <- sample(twitter_sanit,length(twitter_sanit)*0.01)

# Run the cetCorpus function from the "utility" file
tCorp <- getCorpus(twitter)
bCorp <- getCorpus(blogs)
nCorp <- getCorpus(news)

tdm_2 <- TermDocumentMatrix(c(tCorp, bCorp, nCorp), control = list(tokenize = BigramTokenizer)) 
tdm_3 <- TermDocumentMatrix(c(tCorp, bCorp, nCorp), control = list(tokenize = TrigramTokenizer))
tdm_4 <- TermDocumentMatrix(c(tCorp, bCorp, nCorp), control = list(tokenize = QuadgramTokenizer))
tdm_5 <- TermDocumentMatrix(c(tCorp, bCorp, nCorp), control = list(tokenize = PentagramTokenizer))

#Create an SQLite database to hold the terms' frequencies
db <- dbConnect(SQLite(), dbname="train.db")
dbSendQuery(conn=db,
            "CREATE TABLE NGram
            (pre TEXT,
            word TEXT,
            freq INTEGER,
            n INTEGER)")  # ROWID automatically created with SQLite dialect

# Get word frequencies
freq_5 <- tdmToFreq(tdm_5)
freq_4 <- tdmToFreq(tdm_4)
freq_3 <- tdmToFreq(tdm_3)
freq_2 <- tdmToFreq(tdm_2)
 
# Process with pre and current word
processGram(freq_5)
processGram(freq_4)
processGram(freq_3)
processGram(freq_2)

# Insert into SQLite database
sql_5 <- "INSERT INTO NGram VALUES ($pre, $cur, $freq, 5)"
bulk_insert(sql_5, freq_5)
sql_4 <- "INSERT INTO NGram VALUES ($pre, $cur, $freq, 4)"
bulk_insert(sql_4, freq_4)
sql_3 <- "INSERT INTO NGram VALUES ($pre, $cur, $freq, 3)"
bulk_insert(sql_3, freq_3)
sql_2 <- "INSERT INTO NGram VALUES ($pre, $cur, $freq, 2)"
bulk_insert(sql_2, freq_2)

dbDisconnect(db)