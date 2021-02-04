# Utility Functions
library(magrittr)
library(data.table)
library(RWeka)
library(slam) # import the "row_sums()" function

options(mc.cores=1)

getCorpus <- function(v) {
  # Processes a vector of documents into a tm Corpus
  corpus <- VCorpus(VectorSource(v))
  corpus <- tm_map(corpus, stripWhitespace)  # remove whitespace
  corpus <- tm_map(corpus, content_transformer(tolower))  # lowercase all
  corpus <- tm_map(corpus, removeWords, stopwords("english"))  # rm stopwords
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  # corpus <- tm_map(corpus, stemDocument)
  corpus 
}

tokenize <- function(v) {
  # Add spaces before and after punctuation,
  # remove repeat spaces, and split the strings
  gsub("([^ ])([.?!&])", "\\1 \\2 ", v)   %>%
    gsub(pattern=" +", replacement=" ")     %>%
    strsplit(split=" ") %>%
    unlist
}

tdmToFreq <- function(tdm) {
  # Takes tm TermDocumentMatrix and processes into frequency data.table
  freq <- sort(row_sums(tdm, na.rm=TRUE), decreasing=TRUE)
  word <- names(freq)
  dt <- data.table(word=word, freq=freq)
  return(dt)
}

processGram <- function(dt) {
  # Add to n-gram data.table pre (before word) and cur (word itself)
  dt[, c("pre", "cur"):=list(unlist(strsplit(word, "[ ]+?[a-z]+$")), 
                             unlist(strsplit(word, "^([a-z]+[ ])+"))[2]), 
     by=word]
}

bulk_insert <- function(sql, key_counts)
{
  dbBegin(db)
  dbGetPreparedQuery(db, sql, bind.data = key_counts)
  dbCommit(db)
}

UnigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
QuadgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
PentagramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 5, max = 5))