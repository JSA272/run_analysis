## BEGIN SECTION 1
## Read the data,remove extraneous columns containing redundant row numbers
##
## Read Y_test information, convert to a factor vector. Read the activity labels, then apply them to 
## Y_test to create full activitiy information for the test group.
y_test <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep =" ", header = FALSE)
y_test <- y_test[["V1"]]
y_test <- as.factor(y_test)
act <- read.csv("UCI HAR Dataset/activity_labels.txt", sep =" ", header = FALSE, stringsAsFactors = FALSE)
act <- act[["V2"]]
levels(y_test) <- act
## Read the feature.txt file to extract the column names
feat <- read.csv("UCI HAR Dataset/features.txt", sep =" ", header = FALSE, stringsAsFactors=FALSE)
feat <- feat[["V2"]]

## Read data on subject ID numbers for the subject_test.txt file
subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE)

## Read X_test.txt to fill in contents of test group data. Remove empty 
x_test <- scan("UCI HAR Dataset/test/X_test.txt")

## Assemble the various test data sets into a single data.frame object
## First create a numeric matrix using the x_test data
## Then assign those values the names from the feat object
## Then add additional columns for the activity and subject files
test_data <- matrix(x_test, nrow = 2947, ncol = 561, byrow = TRUE)
colnames(test_data) <- feat
test_data <- as.data.frame(test_data)
test_data$subject <- subject_test[[1]]
test_data$activity <- y_test

## Repeat the above steps, for the train data.
y_train <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep =" ", header = FALSE)
y_train <- y_train[["V1"]]
y_train <- as.factor(y_train)

## Change the numerical levels of the y_train data to the levels as described of act.
levels(y_train) <- act

## Read data on subject ID numbers for the subject_test.txt file
subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep =" ", header = FALSE)

## Read X_test.txt to fill in contents of test group data. Remove empty 
x_train <- scan("UCI HAR Dataset/train/X_train.txt")

## Assemble the train datasets into a single train_data data.frame 
## Create a numerical matrix to hold the x_train data, filling in by row
## We then convert the matrix to a data.frame, assign it column names from 
train_data <- matrix(x_train, nrow = 7352, ncol = 561, byrow = TRUE)
train_data <- as.data.frame(train_data)
colnames(train_data) <- feat
train_data$subject <- subject_train[[1]]
train_data$activity <- y_train

## Construct the full data set by combining test_data and train_data
## Completes section 1 of the assignment
data <- rbind(test_data, train_data)

## BEGIN SECTION 2
## Construct goodcolumns, a logical vector containing TRUE for each element of the feat vector that
## contains either "mean()" or "std()"
goodcolumns <- as.logical(grepl("mean()", feat, fixed = TRUE) + grepl("std()", feat, fixed = TRUE))
## Add two additional TRUE values to the end of goodcolumns, to select the subject and activity columns
goodcolumns <- c(goodcolumns, TRUE, TRUE)
## Create a new data.frame using only the columns selected above, completing section 2.
our_data <- data[,goodcolumns]

## Steps 3 and 4 have already been completed due to the strategy taken in step 1, the activity
## numbers have been replaced with the descriptive names from the activity_labels.txt file, and
## the column names have been taken from the features.txt file
## BEGIN SECTION 5
## Create and id variable by pasting subject and activity together 
our_data$id <- paste(our_data[,"subject"], our_data[,"activity"])
clean_data <- split(our_data[,1:66], our_data$id)
clean_data <- sapply(clean_data, function(x) colMeans(x, ))
clean_data <- t(clean_data)

## Creates add, a small data.frame containing the subject and activiy data for each row, to allow
## sorting the rows. Binds add to the clean_data data.frame.
add <- data.frame(matrix(unlist(strsplit(rownames(clean_data), " ")), ncol = 2, byrow = TRUE))
names(add) <- c("subject", "activity")
clean_data <- cbind(add, clean_data)
clean_data$subject <- as.numeric(as.character(clean_data$subject))
## Put the clean_data data.frame in order by subject number
clean_data <- clean_data[order(clean_data$subject,clean_data$activity),]
## Save the clean_data data.fram as clean_data.txt to the working directory.
## This completes Section 5
write.table(clean_data, file = "clean_data.txt", row.names = FALSE)

