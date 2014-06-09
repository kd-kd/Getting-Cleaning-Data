# prerequisits
# unpack zip to ~/UCI, ~/UCI/test, ~/UCI/train
# put this script to your HOME ~

library(reshape2)

# prepare activities
activities<- read.table("~/UCI/activity_labels.txt", sep=" ", stringsAsFactor=FALSE, header=FALSE)
activities.names <- activities$V2
names(activities.names) = activities$V1

# prepare features (mean and std only)
features <- read.table("~/UCI/features.txt", sep=" ", stringsAsFactor=FALSE, header=FALSE)
features.valid <- features[grep("mean\\(\\)|std\\(\\)",features$V2),]

# read test data
X_test <- read.table("~/UCI/test/X_test.txt", header=FALSE, stringsAsFactor=FALSE)
y_test <- read.table("~/UCI/test/y_test.txt", header=FALSE, stringsAsFactor=FALSE)
subject_test <- read.table("~/UCI/test/subject_test.txt", header=FALSE, stringsAsFactor=FALSE)

# select valid columns (mean and std only)
X_test <- X_test[,features.valid$V1]

# read train data
X_train <- read.table("~/UCI/train/X_train.txt", header=FALSE, stringsAsFactor=FALSE)
y_train <- read.table("~/UCI/train/y_train.txt", header=FALSE, stringsAsFactor=FALSE)
subject_train <- read.table("~/UCI/train/subject_train.txt", header=FALSE, stringsAsFactor=FALSE)

# select valid columns (mean and std only)
X_train <- X_train[,features.valid$V1]

# merge test and train data frames
X <- rbind(X_test, X_train)
y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)

# expand data with two additional columns (subject and activity)
X<-cbind(subject$V1, y$V1, X)

# name columns
names(X)=c("subject", "activity", features.valid$V2)

# apply desciptive activity names
X$activity = activities.names[X$activity]

# sort
X <- X[order(X$subject, X$activity),]

# apply colmeans
tidy<-sapply(split(X,list(X$subject, X$activity)),function(x) colMeans(x[,3:68]))

# reformat output
tidy<-t(tidy)
tidy<-as.data.frame(tidy)
tidy<-cbind(colsplit(row.names(tidy),"\\.",c("subject","activity")), tidy)

# output result
write.table(tidy,"tidy.txt",row.names=FALSE)
