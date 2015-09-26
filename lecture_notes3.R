# Subsetting and sorting
# quick review
set.seed(13435)
X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X <- X[sample(1:5),]; X$var2[c(1,3)] = NA
X
"""
 var1 var2 var3
1    2   NA   15
4    1   10   11
2    3   NA   12
3    5    6   14
5    4    9   13
"""

X[,1] # subset a specific column
"[1] 2 1 3 5 4"
X[,"var1"]
"[1] 2 1 3 5 4"
X[1:2,"var2"]
"[1] NA 10"

# logicals, ands, and ors
X[(X$var1 <= 3 & X$var3 > 11),]
"""
  var1 var2 var3
1    2   NA   15
2    3   NA   12
"""
X[(X$var1 <= 3 | X$var3 > 15),]
"""
  var1 var2 var3
1    2   NA   15
4    1   10   11
2    3   NA   12
"""

# dealing with missing values
X[which(X$var2 > 8),] # which() returns indices of
                      # where var2 is >8
"""
  var1 var2 var3
4    1   10   11
5    4    9   13
"""

# sorting
sort(X$var1) # ascending by default
sort(X$var1,decreasing=TRUE)
sort(X$var2,na.last=TRUE) # sorts NAs at the very end
"[1]  6  9 10 NA NA"

# ordering
X[order(X$var1),] # order dataframe on var1
"""
  var1 var2 var3
4    1   10   11
1    2   NA   15
2    3   NA   12
5    4    9   13
3    5    6   14
"""

X[order(X$var1,X$var3),] # order dataframe on var1, then var3

# ordering with plyr
library(plyr)
arrange(X,var1)
"""
  var1 var2 var3
1    1   10   11
2    2   NA   15
3    3   NA   12
4    4    9   13
5    5    6   14
"""
arrange(X,desc(var1))
"""
  var1 var2 var3
1    5    6   14
2    4    9   13
3    3   NA   12
4    2   NA   15
5    1   10   11
"""

# adding rows and columns
X$var4 <- rnorm(5)
X
"""
  var1 var2 var3       var4
1    2   NA   15  2.5437602
4    1   10   11  1.5545298
2    3   NA   12 -0.6192328
3    5    6   14 -0.9261035
5    4    9   13 -0.6654995
"""

Y <- cbind(X,rnorm(5))
Y
"
  var1 var2 var3       var4    rnorm(5)
1    2   NA   15  2.5437602 -0.02166735
4    1   10   11  1.5545298 -0.17411953
2    3   NA   12 -0.6192328  0.23900438
3    5    6   14 -0.9261035 -1.83245959
5    4    9   13 -0.6654995 -0.03718739
"

Z <- rbind(Y,rnorm(5))
Z
"
       var1      var2       var3       var4    rnorm(5)
1  2.000000        NA 15.0000000  2.5437602 -0.02166735
4  1.000000 10.000000 11.0000000  1.5545298 -0.17411953
2  3.000000        NA 12.0000000 -0.6192328  0.23900438
3  5.000000  6.000000 14.0000000 -0.9261035 -1.83245959
5  4.000000  9.000000 13.0000000 -0.6654995 -0.03718739
6 -0.440517 -1.448264 -0.5182457  0.7585272  0.28493532
"

# Summarizing data
if(!file.exists("./data")) {dir.create("./data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl,destfile="./data/restaurants.csv",method="curl")
restData <- read.csv("./data/restaurants.csv")

head(restData,n=3)
"
   name zipCode neighborhood councilDistrict policeDistrict
1   410   21206    Frankford               2   NORTHEASTERN
2  1919   21231  Fells Point               1   SOUTHEASTERN
3 SAUTE   21224       Canton               1   SOUTHEASTERN
                         Location.1
1 4509 BELAIR ROAD\nBaltimore, MD\n
2    1919 FLEET ST\nBaltimore, MD\n
3   2844 HUDSON ST\nBaltimore, MD\n
"

tail(restData,n=3) # last 3 rows in restData

# make summary
summary(restData)
"
                           name         zipCode      
 MCDONALD'S                  :   8   Min.   :-21226  
 POPEYES FAMOUS FRIED CHICKEN:   7   1st Qu.: 21202  
 SUBWAY                      :   6   Median : 21218  
 KENTUCKY FRIED CHICKEN      :   5   Mean   : 21185  
 BURGER KING                 :   4   3rd Qu.: 21226  
 DUNKIN DONUTS               :   4   Max.   : 21287  
 (Other)                     :1293                   
       neighborhood councilDistrict       policeDistrict
 Downtown    :128   Min.   : 1.000   SOUTHEASTERN:385   
 Fells Point : 91   1st Qu.: 2.000   CENTRAL     :288   
 Inner Harbor: 89   Median : 9.000   SOUTHERN    :213   
 Canton      : 81   Mean   : 7.191   NORTHERN    :157   
 Federal Hill: 42   3rd Qu.:11.000   NORTHEASTERN: 72   
 Mount Vernon: 33   Max.   :14.000   EASTERN     : 67   
 (Other)     :863                    (Other)     :145   
                        Location.1      
 1101 RUSSELL ST\nBaltimore, MD\n:   9  
 201 PRATT ST\nBaltimore, MD\n   :   8  
 2400 BOSTON ST\nBaltimore, MD\n :   8  
 300 LIGHT ST\nBaltimore, MD\n   :   5  
 300 CHARLES ST\nBaltimore, MD\n :   4  
 301 LIGHT ST\nBaltimore, MD\n   :   4  
 (Other)                         :1289
"

str(restData) # provides information about the dataframe
              # and each variable.
quantile(restData$councilDistrict,na.rm=TRUE)
quantile(restData$councilDistrict,probs=c(0.5,0.75,0.9))

# make a table
table(restData$zipCode,useNA='ifany') # will count NA as well

# two-dimensional table
table(restData$councilDistrict,restData$zipCode)

# check for missing values
sum(is.na(restData$councilDistrict))
any(is.na(restData$councilDistrict))
all(restData$zipCode > 0)

# row and column sums
colSums(is.na(restData))
all(colSums(is.na(restData))==0)

# values with specific characteristics
table(restData$zipCode %in% c("21212"))
"
FALSE  TRUE 
 1299    28 
"
table(restData$zipCode %in% c("21212", "21213"))
"
FALSE  TRUE 
 1268    59 
"
# show results with logic = TRUE
restData[restData$zipCode %in% c("21212","21213"),]

# cross tabs
data(UCBAdmissions)
DF = as.data.frame(UCBAdmissions)
summary(DF)
xt <- xtabs(Freq ~ Gender + Admit, data=DF)
xt

# flat tables
warpbreaks$replicate <- rep(1:9,len=54)
xt = xtabs(breaks ~.,data=warpbreaks) 
xt
ftable(xt)

# size of a dataset
fakeData = rnorm(1e5)
object.size(fakeData)
"800040 bytes"
print(object.size(fakeData),units="Mb")
"0.8 Mb"

# New variables
# creating sequence
s1 <- seq(1,10,by=2); s1 # min, max, and interval
"[1] 1 3 5 7 9"

s2 <- seq(1,10,length=3); s2 # min, max, and how many
"[1]  1.0  5.5 10.0"

x <- c(1,3,8,25,100); seq(along=x)
"[1] 1 2 3 4 5"

# subsetting variables
restData$nearMe = restData$neighborhood %in% c("Roland Park", "Homeland")
# just added nearMe variable (T/F) based on the two neighborhoods
table(restData$nearMe)

# creating binary variables
restData$zipWrong = ifelse(restData$zipCode < 0, TRUE, FALSE) # is the zipcode less than zero?
table(restData$zipWrong, restData$zipCode <0)

# creating categorical variables
restData$zipGroups = cut(restData$zipCode,breaks=quantile(restData$zipCode))
table(restData$zipGroups)
table(restData$zipGroups,restData$zipCode)

# easier cutting
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode,g=4) # breaks it up into 4 groups / quantiles
table(restData$zipGroups)

# creating factor variables
restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]
class(restData$zcf)

# levels of factor variables
yesno <- sample(c("yes","no"),size=10,replace=TRUE)
yesnofac = factor(yesno,levels=c("yes","no"))
relevel(yesnofac,ref="yes")
as.numeric(yesnofac)

# using the mutate function
library(plyr)
# makes new data frame as restData and zipGroups (quantile)
restData2 = mutate(restData,zipGroups=cut2(zipCode,g=4))
table(restData2$zipGroups)

# common transforms
abs(x) # absolute value
sqrt(x) # square root
ceiling(x)
floor(x)
round(x,digits=n)
signif(x,digits=n)
cos(x), sin(x), etc.
log(x) # natural log
log2(x), log10(x) # other common logs
exp(x) # exponentiating x

# Reshaping data
library(reshape2)
head(mtcars)
"
                   mpg cyl disp  hp drat    wt  qsec vs am gear carb
Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
"

# melting data frames
mtcars$carname <- rownames(mtcars)

# pass df, pass id variables and measure variables
carMelt <- melt(mtcars,id=c("carname","gear","cyl"),measure.vars=c("mpg","hp"))
head(carMelt,n=3)
# creates id vars (carname, gear, cyl),
# then measure vars + value (mpg, hp)
"
        carname gear cyl variable value
1     Mazda RX4    4   6      mpg  21.0
2 Mazda RX4 Wag    4   6      mpg  21.0
3    Datsun 710    4   4      mpg  22.8
"

# casting data frames (reformat into different shapes)
# recast melted dataset (carMelt) for cylinder by count of measure vars (summarize).
cylData <- dcast(carMelt, cyl ~ variable)
cylData
"
  cyl mpg hp
1   4  11 11 # @ 4 cyl, there are 11 mpg and hp entries
2   6   7  7 # @ 6 cyl, there are 7 mpg and hp entries
3   8  14 14 # @ 8 cyl, ...
"
# recast melted dataset (carMelt) for cylinder by mean of measure vars.
cylData <- dcast(carMelt, cyl ~ variable, mean)
cylData

# averaging values
head(InsectSprays)
"
  count spray
1    10     A
2     7     A
3    20     A
4    14     A
5    14     A
6    12     A
"
# take $count, and apply sum function along $spray
tapply(InsectSprays$count,InsectSprays$spray,sum)
"
  A   B   C   D   E   F 
174 184  25  59  42 200 
"

# split
spIns = split(InsectSprays$count, InsectSprays$spray)
spIns # list of values for each $spray

# apply
sprCount = lapply(spIns,sum)
# sum the counts for each $spray
sprCount

# combine
unlist(sprCount)
"
  A   B   C   D   E   F 
174 184  25  59  42 200
"

sapply(spIns,sum) # apply and combine at the same time
"
  A   B   C   D   E   F 
174 184  25  59  42 200
"

# plyr package
ddply(InsectSprays,.(spray),summarize,sum=sum(count))

# creating a new variable
spraySums <- ddply(InsectSprays,.(spray),summarize,sum=ave(count,FUN=sum))
dim(spraySums)
"[1] 72  2"

# Managing data frames with dplyr - introduction
"arrange, filter, select, mutate, rename, summarize"
select - returns a subset of the columns of a data frame
filter - extracts a subset of rows from a data frame based on logical
         conditions
arrange - reorder rows of a data frame
rename - rename variables in a data frame
mutate - add new variables / columns or transform existing variables
summarize - generate summary statistics of different variables in the
            data frame, possibly within strata

"
- The first argument is a data frame
- subsequent args describe what to do with the data frame
- the result is a new data frame
- df must be properly formatted and annotated for this to be useful
"

# Merging data
fileUrl1 = "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 = "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1,destfile="./data/reviews.csv",method="curl")
download.file(fileUrl2,destfile="./data/solutions.csv",method="curl")
reviews = read.csv("./data/reviews.csv"); solutions = read.csv("./data/solutions.csv")
head(reviews,2)
head(solutions,2)
names(reviews)
names(solutions)
mergedData = merge(reviews,solutions,by.x="solution_id",by.y="id",all=TRUE)
head(mergedData)

# default merge
intersect(names(solutions),names(reviews))
mergedData2 = merge(reviews, solutions, all=TRUE)
head(mergedData2)

# join in the plyr package
df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
arrange(join(df1,df2),id)

# if you have multiple data frames
df3 = data.frame(id=sample(1:10),z=rnorm(10))
df_list = list(df1,df2,df3)
join_all(df_list)
