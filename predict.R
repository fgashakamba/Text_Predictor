# Predict, using N-Grams and Stupid Backoff
library(magrittr)
library(stringr)
library(RSQLite)
library(tm)

ngram_backoff <- function(raw, db) {
  # From Brants et al 2007.
  # Find if n-gram has been seen, if not, multiply by alpha and back off
  # to lower gram model. Alpha unnecessary here, independent backoffs.
  
  max = 3  # max n-gram - 1
  
  # process sentence, don't remove stop-words
  sentence <- tolower(raw) %>%
    removePunctuation %>%
    removeNumbers %>%
    stripWhitespace %>%
    str_trim %>%
    strsplit(split=" ") %>%
    unlist
  
  for (i in min(length(sentence), max):1) {
    gram <- paste(tail(sentence, i), collapse=" ")
    sql <- paste("SELECT word, freq FROM NGram WHERE ", 
                 " pre=='", paste(gram), "'",
                 " AND n==", i + 1, " LIMIT 5", sep="")
    res <- dbSendQuery(conn=db, sql)
    predicted <- dbFetch(res, n=-1)
    names(predicted) <- c("Next Possible Word", "Score (Adjusted Freq)")
    print(predicted)
    
    if (nrow(predicted) > 0) return(predicted)
  }
  
  return("It seems our model can't predict the next word for you. Sorry.")
}