#  run_analysis.R
## A explanation of my method

This document explains the code behind run_analysis.R step by step.

The assignment outlines 5 steps:

1. Merge the test and train data sets.
2. Extract only the mean and standard deviation measurements.
3. Use descriptive names for the activities.
4. Label data appropriately.
5. Create tidy data with means for each activity/subject.

In my script, I approach these goals in a slightly different order. As I apply labels to the data throughout the
analysis, Steps 3 and 4 are fulfilled after Step 2 without any additional work. Here's my strategy in detail:

### Assembling the test and train groups separately and joining.

First I put the test and train group data together separately. Each has an x, y and subject txt file associated
with it, and the share features.txt and activity_labels.txt.  For each group, the y and subject information
become columns of their own, while the x data is fed into a set of 561 columns, named by the contents of the
features.txt file.

I had found it difficult to read the x data, as txt files had no way to mark the number of columns. To overcome
this, I created a numeric matrix of the desired dimensons, and read the information using read.lines(). I then
converted the outcome to a data.frame and attached the participant and activity information.

Throughout this stage, I applied the correct descriptive names to each table, by applying the contents of 
features.txt as the column names of the x data for each group, and by replacing the levels of each y column with
the corresponding descriptive name from the levels of the shared activity_labels.txt file.

At this point, the two data.frames, train_data and test_data could easily be joined with the rbind() function. At
this point the data.frame called "data" fulfilled the first requirement.

### Separating the correct columns

I interpreted the direction to select only those columns containing mean or standard devition to mean those 
columns ending with the strings "mean()" or "std()". To that effect, I created a logical vector "goodcolumns" 
contining of the same length as features.txt with TRUE corresponding to each entry that met the criteria using
the grepl() function. I then added 2 addition TRUEs to also include the "subject" and "activity" columns. 

I then created a new data.frame "our_data" by selecting from "data" using the "goodcolumns" vector. This
fulfilled the requirements of the second part, and also the third and fourth.

### Creating the tidy data set

To go from "our_data" to a finished data.frame called "clean_data", created a new "id" variable, split the data,
found the mean for each variable and then reformed the "subject" and "activity" information.

First, I pasted together the "subject" and "activity" fields to create a new variable called "id" with 180 levels.
This allowed me to split the data using this one variable in order to use the sapply() function to run colmeans()
over it. After transposing the resulting data.frame using t(), I had all of my mean data with the features.txt
information as the column labels and my pasted "id" information.

Unfortunatly, the "id" information did not make very good row labels, so I used the strsplit() function to create
a new data.fram called "add" with the separate "subject" and "activity" information. I chose to do this instead of
referring to the previous steps to insure that they matched the current data. 

Finally, I used the write.table() function to output the final tidy data set, fulfilling the final requirements 
for the project.