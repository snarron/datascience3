# Q1
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv "
download.file(fileUrl, destfile="./data/american_community_survey.csv", method="curl")
content <- read.csv("./data/american_community_survey.csv")
dateDownloaded <- date()

DF <- data.frame(content)
table(DF$VAL[DF$VAL>=24]) # returns 24; 53

# Q2
# no R code necessary

# Q3
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx "
download.file(fileUrl, destfile="./data/natural_gas_acquisition_program.xlsx", method="curl")
dat <- read.xlsx("./data/natural_gas_acquisition_program.xlsx", 1, rowIndex=18:23, colIndex=7:15)
sum(dat$Zip*dat$Ext,na.rm=T) # 36534720

# Q4
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
download.file(fileUrl, destfile="./data/baltimore_restaurants.xml", method="curl")
doc <- xmlTreeParse("./data/baltimore_restaurants.xml", useInternal=TRUE)
rootNode <- xmlRoot(doc)
table(xpathSApply(rootNode,"//zipcode",xmlValue))

# Q5
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile="./data/american_community_survey_2006.csv", method="curl")
DT <- fread("./data/american_community_survey_2006.csv")
file = tempfile()
write.table(DT, file=file, row.names=FALSE, col.names=TRUE, sep=",", quote=FALSE)
system.time(rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2])
"""Error: unexpected ';' in "system.time(rowMeans(DT)[DT$SEX==1];""""
system.time(mean(DT$pwgtp15,by=DT$SEX))
"""   user  system elapsed 
  0.000   0.000   0.001 """
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
"""   user  system elapsed 
  0.001   0.000   0.001 """
system.time(mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15))
"""Error: unexpected ';' in "system.time(mean(DT[DT$SEX==1,]$pwgtp15);"""
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
"""user  system elapsed 
    0.003   0.000   0.003 """
system.time(DT[,mean(pwgtp15),by=SEX])
"""   user  system elapsed 
    0.002   0.000   0.002 """