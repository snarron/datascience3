# reading Excel files
if (!file.exists("data")){dir.create("data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileUrl, destfile="./data/cameras.xlsx", method="curl")
dateDownloaded <- date()

# reading XML files
library(XML)
fileUrl <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl,useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
# access root node (first food element)
rootNode[[1]]
# access root attribute of root node
rootNode[[1]][[1]]
# programatically extract part of the file
# (all elements of all tags in the root node)
xmlSApply(rootNode,xmlValue)

# get the items on the menu and prices using XPath
xpathSApply(rootNode,"//name",xmlValue)
xpathSApply(rootNode,"//price",xmlValue)

# extract content by attributes
fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileUrl,useInternal=TRUE)
scores <- xpathSApply(doc,"//li[@class='score']",xmlValue)
teams <- xpathSApply(doc,"//li[@class='team-name']",xmlValue)
scores
teams

# reading JSON
library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
names(jsonData$owner)
jsonData$owner$login
jsonData$owner

# writing data frames to JSON
myjson <- toJSON(iris, pretty=TRUE)
cat(myjson)

# convert back to JSON
iris2 <- fromJSON(myjson)
head(iris2)

# using datatable package
# inherits from the data.frame
library(data.table)

# data.frame example
DF = data.frame(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
head(DF,3)

# data.table example
DT = data.table(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
head(DF,3)

# see all the data tables in memory
tables()

# subsetting rows
DT[2,]
DT[DT$y=='a']
DT[c(2,3)]

# subsetting columns??
DT[,c(2,3)] # not really like data frames
# column subsetting in data.table
{ x = 1
  y = 2
}
k = {print(10); 5} # prints 10
print(k) # prints 5

DT[,list(mean(x),sum(z))] # passing a list of functions
DT[,table(y)] # getting a table of y
# adding new columns
DT[,w:=z^2] # := adds columns
DT2 <- DT # assign DT to DT2 (new table)
DT[, y:=2] # make change in original DT table
head(DT2,n=3) # changes to DT are not carried over to DT2

# multiple operations
DT[,m:= {tmp <- (x+z); log2(tmp+5)}] # final result assigned to m

# plyr-like operations
DT[,a:=x>0]
DT[,b:= mean(x+w), by=a] # by=a -> group by a = TRUE

# special variables
# .N -> an integer, length 1, containing the number r
set.seed(123);
DT <- data.table(x=sample(letters[1:3],1E5,TRUE))
DT[, .N, by=x] # counts the number of elements grouped by x (letter a, b, and c)

# keys
DT <- data.table(x=rep(c("a","b","c"),each=100),y=rnorm(300))
setkey(DT,x)
DT['a']

# joins
DT1 <- data.table(x=c('a','a','b','dt1'), y=1:4)
DT2 <- data.table(x=c('a','b','dt2'),z=5:7)
setkey(DT1,x); setkey(DT2,x)
merge(DT1,DT2)

# fast reading
big_df <- data.frame(x=rnorm(1E6), y=rnorm(1E6))
file <- tempfile()
write.table(big_df, file=file, row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)
system.time(fread(file))
system.time(read.table(file, header=TRUE, sep="\t"))
