# This is the Course Project for Getting and Cleaning Data

The task of this assignment was to create an R script called run_analysis.R that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

In my Script run_analysis.R I changed the sequence of steps as follows

1. Set some variables where to find the downloaded and extracted data.
2. Download the zip file, extract the data and delete the zip file, if the data folder does not exist.
3. Read in the feature and activity labels and remove all the dots and paranthesis from the labels. I did not translate the shortform into a descriptive form because the labels would otherwise be much too long. See the Code Book for a translation.
4. Read in the test data using the feature names from step 3 to label the columns.
4.1 select only the columns including the measurments on mean an standard deviation. After this step only those columns which labels match "(mean|std)[xyz]$" remain.
4.2 Include columns for the oberserved subject and the performed activity.
5. Read in the training data using the feature names from step 3 to label the columns.
5.1 select only the columns including the measurments on mean an standard deviation. After this step only those columns which labels match "(mean|std)[xyz]$" remain.
5.2 Include columns for the oberserved subject and the performed activity.
6. Append the training set to the test set and calculate the mean on every measurement grouped by subject an activity.
7. Finally save the tidy data set to tidyDataSet.txt in the working directory and remove all temporary data sets