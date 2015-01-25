library(dplyr)

setwd("C:\\Users\\tgaertner\\Desktop\\Coursera\\3. Getting and Cleaning Data\\Week 3\\getdata_projectfiles_UCI HAR Dataset")

# Merges the training and the test sets to create one data set

featureData <- read.table(".\\UCI HAR Dataset\\features.txt") ## read in feauture name data
featureNames <- as.character(featureData[,2]) ## create a list of 561 features
featureNames <- make.names(featureNames, unique=TRUE)

# Appropriately cleans feature names to have descriptive variable names
featureNames <- gsub("()", "", featureNames, fixed = TRUE)

activityData <- read.table(".\\UCI HAR Dataset\\activity_labels.txt", col.names=c("ID", "Activity")) ## read in feauture name data

## TRAIN DATA
X_trainData <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt", col.names = featureNames) 
Y_trainData <- read.table(".\\UCI HAR Dataset\\train\\Y_train.txt", col.names = c("Activity_ID")) 
subject_trainData <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt", col.names = c("Subject")) 

trainData <- cbind(subject_trainData, Y_trainData, X_trainData)

## TEST DATA
X_testData <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt", col.names = featureNames)
Y_testData <- read.table(".\\UCI HAR Dataset\\test\\Y_test.txt", col.names = c("Activity_ID"))
subject_testData <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt", col.names = c("Subject"))

testData <- cbind(subject_testData, Y_testData, X_testData)

## FULL DATA
fullData <- rbind(trainData,testData)

# Extracts only the measurements on the mean and standard deviation for each measurement
selectData <- select(fullData, Subject, Activity_ID, contains("mean"),contains("std"))

# Uses descriptive activity names to name the activities in the data set
selectDescribeData <- merge(activityData,selectData,by.x = "ID",by.y = "Activity_ID")

# From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject
by_group <- group_by(selectDescribeData, Subject, Activity)
tidyData <- summarise_each(by_group, funs(mean))

# tidyData txt file creation
write.table(tidyData, file = ".\\Getting-and-Cleaning-Data\\tidyData.txt", row.names = FALSE) ## Creates txt file of final tidy data set

# Codebook.md file creation
library(memisc)

Data <- data.set(tidyData)
code.book <- codebook(Data)

#sink(file = ".\\Getting-and-Cleaning-Data\\Codebook.md")
code.book
sink()