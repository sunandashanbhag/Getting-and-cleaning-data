library(plyr)


#Read training data
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

#Read test data
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# merge test and training data
x_mrg <- rbind(x_train, x_test)
y_mrg <- rbind(y_train, y_test)
subject_mrg <- rbind(subject_train, subject_test)

#read column names and numbers
columndata <- read.table("features.txt")
activitydata <- read.table("activity_labels.txt")

columnname <- columndata[,2]
# get only columns with mean() or std() in their names
meanstd <- grep("-(mean|std)\\(\\)", columnname)

# subset x_mrg
x_meanstd <- x_mrg[, meanstd]
#name columns

x_final<-x_meanstd

# update activity number with names
y_mrg[, 1] <- activitydata[y_mrg[, 1], 2]
y_final<-y_mrg

# correct column name
names(subject_mrg) <- "subject"
names(y_final)<-"activity"
names(x_final) <- features[meanstd, 2]

#create final dataset
final_data <- cbind(x_final, y_final, subject_mrg)

#create avg dataset
avg_dataset<-aggregate(x=final_data[,1:66], by=list(final_data$subject, final_data$activity), FUN=mean)
colnames(avg_dataset)[2]<-"activity"
colnames(avg_dataset)[1]<-"subject"

write.table(avg_dataset, "average_dataset.txt", row.name=FALSE)
