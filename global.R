# To intiate the libaries and functions

options(warn=-1)
options(stringsAsFactors=FALSE)
options(check.names=FALSE)
suppressMessages(library(RMySQL))
suppressMessages(library(DT))

my.vector2set <- function(x, quote=TRUE) {
  if (quote) x <- sprintf("'%s'", x)
  sprintf("(%s)", paste(x, collapse=","))
}


my.bf2_connect <- function() {
  if (grepl(Sys.info()["nodename"], pattern="bf2-compute01")) {
    dbConnect(MySQL(), user = "tnguyen", password="welcome2bf2", dbname = "bf2", host = "127.0.0.1", port = c(3306))
  } else {
    tryCatch(dbConnect(MySQL(), user = "tnguyen", password="welcome2bf2", dbname = "bf2", host = "127.0.0.1", port = c(1211)),
             error = function(e) {
               dbConnect(MySQL(), user = "tnguyen", password="welcome2bf2", dbname = "bf2", host = "127.0.0.1", port = c(3306))
             }
    )
  }
}

# this function is to load data from database by running SQL query
load_data <- function(query) {
  if (current_user == "none") return(NULL)
  
  # process user input query
  query <- trimws(query)
  query <- trimws(unlist(strsplit(query, split = ",")))
  query <- trimws(unlist(strsplit(query, split = " ")))
  query <- query[query != ""]
  query <- my.vector2set(query)
  
  # load db
  conn <- my.bf2_connect()
  tab <- dbGetQuery(conn, sprintf("select * from ppi_multipathogen as t1 JOIN ms_pathogen as t2 ON t1.pathogen = t2.pathogen 
                                  where PreyUniprotName is not null and (PreyGeneName in %s or t1.pathogen in %s) 
                                  order by PreyGeneName, MIST desc", 
                                  query, query))
  cl <- dbDisconnect(conn)
  
  # post process the data-frame
  for (v in c("MIST", "Abundance", "Reproducibility", "Specificity")) {
    tab[,v] <- signif(tab[,v], 2)
  }
  
  # create link to uniprot
  tab$Prey = sprintf('<a href="https://www.uniprot.org/uniprot/%s" target="_blank">%s</a>', tab$Prey, tab$Prey)
  rownames(tab) <- NULL
  return(tab)
}

fields <- c("pathogen",
            "pathogen_name",
            "cell_line",
            "Prey",
            "PreyGeneName",
            "MIST",
            "Abundance",
            "Reproducibility",
            "Specificity",
            "Bait"
            )

current_user <- "none"
public_datasets <- c("Ebola-HEK293T","Ebola-HUH7","KSHV-HEK293T","HIV-HEK293T","HIV-Jurkat","HPV-C33A","HPV-HEK293T","HPV-Het1A","Mtb-HEK293T","Zika-HEK293T","Dengue-HEK293T")