# Reading from mysql
ucscDb <- dbConnect(MySQL(),user="genome",
                    host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb,"show databases;"); dbDisconnect(ucscDb);

# connect to the hg19 database
hg19 <- dbConnect(MySQL,user="genome",db="hg19",
                  host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)

allTables[1:5]

# looking at hg19 db; what are the fields in the affy... table?
dbListFields(hg19,"affyU133Plus2")

dbGetQuery(hg19, "select count(*) from affyU133Plus2")

affyData <- dbReadTable(hg19,"affyU133Plus2")
head(affyData)

# select a specific subset
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
addyMix <- fetch(query); quantile(affyMis$missMatches)

# fetching data into memory - only for a smaller subset!
affyMisSmall <- fetch(query,n=10); dbClearResult(query);

dim(affyMisSmall)

# close the connection
dbDisconnect(hg19)

# Reading HDF5
# used for storing large data sets
# hierarchical data format = HDF
# groups containing zero or more data sets and metadata
## have a group header with group name and list of attributes
## have a group symbol table with a list of objects in group
# datasets multidimensional array of data elements with metadata
## have a header with name, datatype, dataspace, and storage layout
## have a data array with the data

# install hdf5 package
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")

# import hdf5
library(rhdf5)
created = h5createFile("example.h5")
created

# create groups
created = h5createGroup("example.h5","foo")
created = h5createGroup("example.h5","baa")
# create a subgroup
created = h5createGroup("example.h5","foo/foobaa")

# show groups
h5ls("example.h5")
"""
  group   name     otype dclass dim
0     /    baa H5I_GROUP           
1     /    foo H5I_GROUP           
2  /foo foobaa H5I_GROUP 
"""

# write to groups
A = matrix(1:10,nr=5,nc=2)
h5write(A,"example.h5","foo/A")
B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
attr(B,"scale") <- "liter"
h5write(B,"example.h5","foo/foobaa/B")
h5ls("example.h5")
"""
        group   name       otype  dclass       dim
0           /    baa   H5I_GROUP                  
1           /    foo   H5I_GROUP                  
2        /foo      A H5I_DATASET INTEGER     5 x 2
3        /foo foobaa   H5I_GROUP                  
4 /foo/foobaa      B H5I_DATASET   FLOAT 5 x 2 x 2
"""

# write a dataset
df = data.frame(1L:5L,seq(0,1,length.out=5),
                c("ab","cde","fghi","a","s"), stringsAsFactors=FALSE)
h5write(df,"example.h5","df")
h5ls("example.h5")
"""
        group   name       otype   dclass       dim
0           /    baa   H5I_GROUP                   
1           /     df H5I_DATASET COMPOUND         5
2           /    foo   H5I_GROUP                   
3        /foo      A H5I_DATASET  INTEGER     5 x 2
4        /foo foobaa   H5I_GROUP                   
5 /foo/foobaa      B H5I_DATASET    FLOAT 5 x 2 x 2
"""

# reading data
readA = h5read("example.h5","foo/A")
readB = h5read("example.h5","foo/foobaa/B")
readdf = h5read("example.h5","df")
readA
"""
     [,1] [,2]
[1,]    1    6
[2,]    2    7
[3,]    3    8
[4,]    4    9
[5,]    5   10
"""

# writing and reading chunks
h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1))
h5read("example.h5","foo/A")
"""
     [,1] [,2]
[1,]   12    6
[2,]   13    7
[3,]   14    8
[4,]    4    9
[5,]    5   10
"""

# Reading data from the web
# getting data off webpages - readLines()
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con) # make sure to close the connection
htmlCode

# parsing with XML
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=T)
xpathSApply(html, "//title", xmlValue)
"""
[1] "Jeff Leek - Google Scholar Citations"
"""
xpathSApply(html, "//td[@id='col-citedby']", xmlValue)

# GET from the httr package
library(httr); html2 = GET(url)
content2 = content(html2,as="text")
parsedHtml = htmlParse(content2,asText=TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)
"""
[1] "Jeff Leek - Google Scholar Citations"
"""

# accessing websites with passwords
pg1 = GET("http://httpbin.org/basic-auth/user/passwd")
pg1
"""
Response [http://httpbin.org/basic-auth/user/passwd]
  Date: 2015-09-20 01:54
  Status: 401
  Content-Type: <unknown>
<EMPTY BODY>
"""
pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
          authenticate("user","passwd"))
pg2
"""
Response [http://httpbin.org/basic-auth/user/passwd]
  Date: 2015-09-20 01:54
  Status: 200
  Content-Type: application/json
  Size: 47 B
{
  "authenticated": true, 
  "user": "user"
}
"""
names(pg2)
"""
 [1] "url"         "status_code" "headers"     "all_headers" "cookies"    
 [6] "content"     "date"        "times"       "request"     "handle" 
"""

# using handles
google = handle("http://google.com") # save google.com as a handle
pg1 = GET(handle=google,path="/")
pg2 = GET(handle=google,path="search")

# Reading from APIs
# accessing Twitter from R
myapp = oauth_app("twitter",
                  key="yourConsumerKeyHere",secret="ourConsumerSecretHere")
sig = signoauth1.0(myapp,
                   token="yourTokenHere",
                   token_secret="yourTokenSecretHere")
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json",sig)

# converting the json object
json1 = content(homeTL)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]

# Reading from other sources
# interacting more directly with files
"""
file - open a connection to a text file
url - open a connection to url
gzfile - open a connection to a .gz file
bzfile - open a connection to a .bz2 file
?connections for more information
REMEMBER TO CLOSE CONNECTIONS
"""
