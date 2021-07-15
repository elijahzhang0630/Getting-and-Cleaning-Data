subject_test <- read.table("~/Downloads/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
X_test <- read.table("~/Downloads/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
y_test <- read.table("~/Downloads/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
subject_train <- read.table("~/Downloads/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
X_train <- read.table("~/Downloads/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
y_train <- read.table("~/Downloads/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")

x_data<- rbind(X_train,X_test)
y_data<- rbind(y_train,y_test)
s_data<- rbind(subject_train,subject_test)

features <- read.table("~/Downloads/UCI HAR Dataset/features.txt", quote="\"", comment.char="")
activity_labels <- read.table("~/Downloads/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
activity_labels[,2]<- as.character(activity_labels[,2])

selectedCols <- grep("-(mean|std).*", as.character(features[,2]))
selectedColNames <- features[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)

x_data <- x_data[selectedCols]
allData <- cbind(s_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

allData$Activity <- factor(allData$Activity, levels = activity_labels[,1], labels = activity_labels[,2])
allData$Subject <- as.factor(allData$Subject)

meltedData <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)

write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)