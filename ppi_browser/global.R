options(warn=-1)
options(stringsAsFactors=FALSE)
options(check.names=FALSE)
suppressMessages(library(parallel))
suppressMessages(library(data.table))
suppressMessages(library(RMySQL))
suppressMessages(library(DT))
suppressMessages(library(RCurl))
suppressMessages(library(sqldf))

my.vector2set <- function(x, quote=TRUE) {
  if (quote) x <- sprintf("'%s'", x)
  sprintf("(%s)", paste(x, collapse=","))
}


my.bf2_connect <- function() {
  return (1)
}

load_data <- function(query) {
  query <- trimws(query)
  query <- trimws(unlist(strsplit(query, split = ",")))
  query <- trimws(unlist(strsplit(query, split = " ")))
  query <- query[query != ""]
  query <- my.vector2set(query)
  
  conn <- my.bf2_connect()
  tab <- dbGetQuery(conn, sprintf("select * from ppi_multipathogen where 
                                  PreyUniprotName is not null and (PreyGeneName in %s or pathogen in %s) 
                                  order by PreyGeneName, MIST desc", 
                                  query, query))
  cl <- dbDisconnect(conn)
  for (v in c("MIST", "Abundance", "Reproducibility", "Specificity")) {
    tab[,v] <- signif(tab[,v], 2)
  }
  tab$Prey = sprintf('<a href="https://www.uniprot.org/uniprot/%s" target="_blank">%s</a>', tab$Prey, tab$Prey)
  rownames(tab) <- NULL
  return(tab)
}

fields <- c("pathogen",
            "cell_line",
            "Prey",
            "PreyGeneName",
            "MIST",
            "Abundance",
            "Reproducibility",
            "Specificity",
            "Bait"
            )
