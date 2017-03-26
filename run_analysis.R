path <- file.path("/Users/priyansh/Desktop/Old Desktop/Coursera/Getting and Cleaning Data/UCI HAR Dataset")
files<-list.files(path,recursive = TRUE)
#print(files)
dataActivityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

###MERGING DATASETS as no  names (merge by rbind)

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

#print(str(dataSubject))
##NAME THE HEAD
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
#print(dataFeaturesNames)

data2 <- cbind(dataSubject, dataActivity)
finalData <- cbind(dataFeatures, data2)

## MEAN AND SD EXTRACT
## grep used to extract only mean or std 
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
finalData<-subset(finalData,select=selectedNames)
#str(finalData)

## USE DESCRIPTIVE ACTIVITY NAMES

activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)
print(activityLabels)
finalData$activity<-factor(finalData$activity,labels=activityLabels$V2)
#print(head(finalData$activity,30))

### LABEL DATA SET WITH DESCRIPTIVE VARIABLE NAMES

names(finalData)<-gsub("^t", "time", names(finalData))
names(finalData)<-gsub("^f", "frequency", names(finalData))
names(finalData)<-gsub("Acc", "Accelerometer", names(finalData))
names(finalData)<-gsub("Gyro", "Gyroscope", names(finalData))
names(finalData)<-gsub("Mag", "Magnitude", names(finalData))
names(finalData)<-gsub("BodyBody", "Body", names(finalData))

## CREATE ANOTHER TIDY DATASET

library(plyr);
finalData2<-aggregate(. ~subject + activity, finalData, mean)
finalData2<-finalData2[order(finalData2$subject,finalData2$activity),]
write.table(finalData2, file = "tidydata.txt",row.name=FALSE)

