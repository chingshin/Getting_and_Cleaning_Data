library(dplyr)
library(stringr)

# 1. Create some variables and folders
# set the base folder where to download and extract the data
basefolder <- "."

# after extracting the data from the zip file, the data files are stored in 
# the datafolder
datafolder <- paste(basefolder, "/UCI HAR Dataset", sep="")

# 2. Download the zip file, extract the data and delete the zip file, 
#    if the data folder does not exist
if(!file.exists(datafolder)) {
    temp <- paste0(basefolder, "/temp.zip")
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ",
               destfile=temp, mode="wb")
    write.table(date(), file="zip_file_downloaded.txt", 
                row.names=FALSE, col.names=FALSE)
    unzip(temp, exdir=basefolder)
    unlink(temp)
}

# 3. Read in the feature and activity labels and remove all the dots and 
#    paranthesis from the labels. I did not translate the shortform into a
#    descriptive form because the labels would otherwise be much too long.
#    See the Code Book for a translation.
features <- read.table(paste0(datafolder, "/features.txt"), 
                       col.names=c("feature_id", "feature"))
features <- tolower(gsub("[^[:alnum:]]","",features$feature))
activities <- read.table(paste0(datafolder, "/activity_labels.txt"), 
                         col.names=c("activity_id", "activity"))

# 4. Read in the test data using the feature names from step 3 to label the columns
X_test <- read.table(paste0(datafolder, "/test/X_test.txt"), col.names=features)

# 4.1 select only the columns including the measurments on mean an standard deviation. 
#     After this step only those columns which labels match "(mean|std)[xyz]$" remain.
X_test <- select(X_test, matches("(mean|std)[xyz]$"))

# 4.2 Include columns for the oberserved subject and the performed activity
subject_test <- read.table(paste0(datafolder, "/test/subject_test.txt"), 
                           col.names=c("subject_id"))
y_test <- read.table(paste0(datafolder, "/test/y_test.txt"), 
                     col.names=c("activity_id"))
y_test <- merge(y_test, activities)
X_test <- cbind(subject=subject_test[[1]], activity=y_test[[2]], X_test)

# 5. Read in the training data using the feature names from step 3 to label the columns
X_train <- read.table(paste0(datafolder, "/train/X_train.txt"), 
                      col.names=features)

# 5.1 select only the columns including the measurments on mean an standard deviation. 
#     After this step only those columns which labels match "(mean|std)[xyz]$" remain.
X_train <- select(X_train, matches("(mean|std)[xyz]$"))

# 5.2 Include columns for the oberserved subject and the performed activity
subject_train <- read.table(paste(datafolder, "/train/subject_train.txt", sep=""), 
                            col.names=c("subject_id"))
y_train <- read.table(paste0(datafolder, "/train/y_train.txt"), 
                      col.names=c("activity_id"))
y_train <- merge(y_train, activities)
X_train <- cbind(subject=subject_train[[1]], activity=y_train[[2]], X_train)

# 6. Append the training set to the test set and calculate the mean
#    on every measurement grouped by subject an activity.
X_tidy <- rbind(X_test, X_train)
X_tidy <- aggregate(X_tidy[,3:50], 
               list(subject=X_tidy$subject, activity=X_tidy$activity), mean)
X_tidy <- X_tidy[order(X_tidy$subject,X_tidy$activity),]

# 7. Finally save the tidy data set and remove all temporary data sets
write.table(X_tidy, file="tidyDataSet.txt", row.name=FALSE)
rm(features, activities, subject_test, subject_train, y_test, y_train, X_test, X_train)
