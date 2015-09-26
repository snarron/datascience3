# Q1
url <- "https://api.github.com/users/jtleek/repos"
html <- GET(url)
names(html)
"""
 [1] "url"         "status_code" "headers"     "all_headers" "cookies"    
 [6] "content"     "date"        "times"       "request"     "handle"  
"""
html[7]
jsonContent <- content(html)
names(jsonContent)

# Q2
install.packages("sqldf")
library("sqldf")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv "
# ended up doing it in excel

# Q3
# did it in excel

# Q4
con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)
nchar(htmlCode[10])
nchar(htmlCode[20])
nchar(htmlCode[30])
nchar(htmlCode[100])

# Q5
x <- read.fwf(
  file=url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"),
  skip=4,
  widths=c(12, 7,4, 9,4, 9,4, 9,4))
head(x)
sum(x$V4[1:1254]) # had to restrict row num because of
                  # underlying source data updates.