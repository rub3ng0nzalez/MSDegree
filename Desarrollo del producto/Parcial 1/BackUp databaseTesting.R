install.packages("RMySQL")

library("RMySQL")
con <- dbConnect(MySQL(),user = 'root', password = 'password', host ='localhost', port = 3307, dbname ='information_schema')
dbGetQuery(con,'show databases;')