library(dplyr)
# Q1
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl,destfile="./data/idahoMicrodata.csv",method="curl")
idahoMicrodata <- read.csv("./data/idahoMicrodata.csv")
idahoDataframe <- data.frame(idahoMicrodata)
agricultureLogical <- idahoMicrodata$ACR == 3 & idahoMicrodata$AGS == 6
which(agricultureLogical)[1:3]
"[1] 125 238 262"

# which() tutorial
"http://www.endmemo.com/program/R/which.php"

# Q2
install.packages("jpeg")
library("jpeg")
?jpeg
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg",destfile="./data/photo.jpg",method="curl",mode="wb")
photo <- readJPEG("./data/photo.jpg", native=TRUE)
quantile(photo,probs=c(0.3,0.8))
"
      30%       80% 
-15259150 -10575416
"

# Q3
library("data.table")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl,destfile="./data/gdp190.csv",method="curl")
gdp190 <- data.table(read.csv("./data/gdp190.csv",skip=4),nrows=190)
gdp190 <- gdp190[X!=""]
gdp190 <- gdp190[,list(X,X.1,X.2,X.3,X.4)]
setnames(gdp190,c("X", "X.1", "X.3", "X.4"), c("CountryCode", "rankingGDP", "Long.Name", "gdp"))

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl,destfile="./data/education.csv",method="curl")
education <- data.table(read.csv("./data/education.csv"))

head(education$CountryCode)
head(gdp190)
finalDt <- merge(gdp190,education,all=TRUE,by=c("CountryCode"))
sum(!is.na(unique(finalDt$rankingGDP)))
finalDt[order(rankingGDP),list(CountryCode,Long.Name.x,Long.Name.y,rankingGDP,gdp)][1:50]

# Q4
finalDt[,mean(rankingGDP,na.rm=TRUE),by=Income.Group]

# Q5
breaks <- quantile(finalDt$rankingGDP, probs = seq(0.0, 1.0, 0.2), na.rm = TRUE)
finalDt$quantileGDP <- cut(finalDt$rankingGDP, breaks = breaks)
finalDt[Income.Group == "Lower middle income", .N, by = c("Income.Group", "quantileGDP")]