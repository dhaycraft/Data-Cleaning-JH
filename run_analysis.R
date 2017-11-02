#Data Cleaning Project
#1
##Download and unzip file from internet
url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(url,temp)
unzip(temp)


#Read Tables for Testing and Training Sets
#Test
X_test=read.table("UCI HAR Dataset/test/X_test.txt")
Y_test<- read.table("UCI HAR Dataset/test/Y_test.txt")
Subject_test <-read.table("UCI HAR Dataset/test/subject_test.txt")

#Train
X_train<- read.table("UCI HAR Dataset/train/X_train.txt")
Y_train<- read.table("UCI HAR Dataset/train/Y_train.txt")
Subject_train <-read.table("UCI HAR Dataset/train/subject_train.txt")

#Features
Features<-read.table("UCI HAR Dataset/features.txt")
Activity<-read.table("UCI HAR Dataset/activity_labels.txt")

#Merge Testing and Training Sets
X<-rbind(X_test, X_train)
Y<-rbind(Y_test, Y_train)
Subject<-rbind(Subject_test,Subject_train)


#2
#Get Features related to mean() and std()

Feature_Select<-grep("mean\\(\\)|std\\(\\)", Features[,2])

#Select Columns that are related to mean() and std()
X=X[,Feature_Select]
dim(X)


#3
#Add descriptors to Y from Activity data set
Y[,1]<-Activity[Y[,1],2] ## replacing numeric values with lookup value from activity.txt; won't reorder Y set
table(Y) 


#4 
#Label all columns in data set with appropriate names

data_names<-Features[Feature_Select,2]
names(X)<-data_names
names(Subject)<-"Subject_ID"
names(Y)<-"Activity"


n.data=cbind(Subject,X,Y)

dim(n.data)


#5
#Tidy Data Set From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(data.table)
TidyData<-data.table(n.data)
TidyData <- TidyData[, lapply(.SD, mean), by = 'Subject_ID,Activity'] ## features average by Subject and by activity
dim(TidyData)

#Write File in Working Directory

write.table(TidyData, file = "TidyData.txt", row.names = FALSE)
