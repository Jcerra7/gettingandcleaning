library(dplyr)

# read train data, test data, description, and activity labels.
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

varnames <- read.table("./UCI HAR Dataset/features.txt")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Merge the training and the test sets.
xtotal <- rbind(xtrain, xtest)
ytotal <- rbind(ytrain, ytest)
subtotal <- rbind(subtrain, subtest)

# Extracts only the mean and standard deviation.
selected_var <- varnames[grep("mean\\(\\)|std\\(\\)",varnames[,2]),]
xtotal <- xtotal[,selected_var[,1]]

# Uses descriptive activity names to name the activities in the data set
colnames(ytotal) <- "activity"
ytotal$activitylabel <- factor(ytotal$activity, labels = as.character(activity_labels[,2]))
activitylabel <- ytotal[,-1]

# Labels the data set with variable names.
colnames(xtotal) <- varnames[selected_var[,1],2]

# Creates a second tidy dataset with avg of each variable for each avitivity in each subject.
colnames(subtotal) <- "subject"
total <- cbind(xtotal, activitylabel, subtotal)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
