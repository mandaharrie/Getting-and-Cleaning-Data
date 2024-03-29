library(dplyr)

# Read train data

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Read test data

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Read data description

variable_names <- read.table("./UCI HAR Dataset/features.txt")

# Read activity labels

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# 1) Merges the training and the test sets to create one data set.

X_data <- rbind(X_train, X_test)
Y_data <- rbind(Y_train, Y_test)
Sub_data <- rbind(Sub_train, Sub_test)

# 2) Extracts only the measurements on the mean and standard deviation for each measurement.

selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_data <- X_data[,selected_var[,1]]

# 3) Uses descriptive activity names to name the activities in the data set

colnames(Y_data) <- "activity"
Y_data$activitylabel <- factor(Y_data$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_data[,-1]

# 4) Appropriately labels the data set with descriptive variable names.

colnames(X_data) <- variable_names[selected_var[,1],2]

# 5) From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.

colnames(Sub_data) <- "subject"
total <- cbind(X_data, activitylabel, Sub_data)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)