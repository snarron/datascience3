"""
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation
   for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data
   set with the average of each variable for each activity and each subject.
"""

# Load the data.table library
library(data.table)
library(dplyr)
library(plyr)
library(reshape2)
# Assign file path for testing and training data sets
testXFileUrl <- "./UCI HAR Dataset/test/X_test.txt"
trainXFileUrl <- "./UCI HAR Dataset/train/X_train.txt"
testYFileUrl <- "./UCI HAR Dataset/test/y_test.txt"
trainYFileUrl <- "./UCI HAR Dataset/train/y_train.txt"
# Assign file path for feature.txt
featureFileUrl <- "./UCI HAR Dataset/features.txt"
# Assign file path for subject information
testSubjectFileUrl <- "./UCI HAR Dataset/test/subject_test.txt"
trainSubjectFileUrl <- "./UCI HAR Dataset/train/subject_train.txt"
activityLabelFileUrl <- "./UCI HAR Dataset/activity_labels.txt"

# Read test, train, feature, and subject data
testXData <- read.table(testXFileUrl)
trainXData <- read.table(trainXFileUrl)
testSubjectData <- read.table(testSubjectFileUrl)
testYData <- read.table(testYFileUrl)
trainYData <- read.table(trainYFileUrl)
featureData <- read.table(featureFileUrl)
trainSubjectData <- read.table(trainSubjectFileUrl)
activityLabelData <- read.table(activityLabelFileUrl)

# Merge test and training data
mergedResults <- rbind(testXData,trainXData)
colnames(mergedResults) <- featureData[,2]

# Merge test and training label
mergedLabel <- rbind(testYData,trainYData)
mergedLabel <- merge(mergedLabel,activityLabelData, by=1)[,2]

# Merge test and training subjects
mergedSubject <- rbind(testSubjectData,trainSubjectData)
colnames(mergedSubject) <- "subject"

# Merge results, label, and subject tables
mergedData <- cbind(mergedSubject,mergedLabel,mergedResults)

# Create a data table containing mean and std vars
relevantCols <- grep("-mean|-std", colnames(mergedData))
cleansedResult <- mergedData[,c(1,2,relevantCols)]
"For testing purposes"
"head(cleansedResult)"

# Calculate the overrall mean by sunject and label
meltedResult <- melt(cleansedResult,id.var = c(1,2))
meanOfResult <- dcast(meltedResult, meltedResult[,1]+meltedResult[,2] ~ variable, mean)

# Save result data
write.table(meanOfResult, file="./data/tidy_data.txt", row.name=FALSE)

head(meanOfResult)
