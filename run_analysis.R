library(tidyr)
library(dplyr)

# This block reads the training measurements and the test measurements
# from their respective files, and then combines them into one data frame.
train_features <- read.table("train/X_train.txt")
test_features <- read.table("test/X_test.txt")
combined_data <- rbind(train_features, test_features)

# This block reads the names of the measurements from the features.txt file, and
# makes them the column names for the combined_data variable defined earlier.
column_names <- scan(file = "features.txt", what = "character", sep = "\n")
# Since each line in the file is numbered (e.g. "1 tBodyAcc-mean()-X"), the 
# sub function substitutes the number and space with a blank string effectively
# deleting it.
column_names <- sub("^[0-9]* ", "", column_names)
# make.names transforms the column names into syntactically valid strings.
colnames(combined_data) <- make.names(column_names, unique = TRUE, allow_ = TRUE)

# Only the mean and standard deviation for each measurement are needed.
target_data <- select(combined_data, matches("mean|std"))
target_data <- tbl_df(target_data)

# This block reads in the activity label for each row in the
# training and test data sets and combines them into a new 
# column in target_data.
train_labels <- scan("train/y_train.txt")
test_labels <- scan("test/y_test.txt")
combined_labels <- c(train_labels, test_labels)
target_data$activityLabel <- combined_labels

# Similar to the column names, the list of activity names is numbered. The read.table
# function is used, which separates the numbers and labels, and then the column containing
# the labels is selected via subscript.
activity_labels <- read.table("activity_labels.txt")[[2]]
# Creates a new column called activityName, and then looks up the appropriate
# value based on the corresponding value in the activityLabel column.
target_data$activityName <- activity_labels[target_data$activityLabel]

# This block reads the training subject ids and the test subject ids
# from their respective files, and then combines them into one vector.
train_subjects <- scan("train/subject_train.txt")
test_subjects <- scan("test/subject_test.txt")
combined_subjects <- c(train_subjects, test_subjects)
target_data$subject <- combined_subjects

# This creates an id column
target_data$id <- c(1:nrow(target_data))

# This translates the wide data format into the long data format. id, activityLabel,
# activityName, and subject are all excluded because they are variables.
target_data <- target_data %>%
	gather(measure, value, -id, -activityLabel, -activityName, -subject)

# This block creates the axis and stat variables. The values depend on the value inside
# measure column created by gather(). 
target_data$axis <- ifelse(grepl("...X", target_data$measure), "x", ifelse(grepl("...Y", target_data$measure), "y", "z"))
target_data$stat <- ifelse(grepl("[a-zA-Z]*.mean", target_data$measure), "mean", "std")
# Once the data is parsed, this function cleans up the values in the measure column by eliminating
# the axis and stat information from it.
target_data$measure <- substr(target_data$measure, 1, regexpr("\\.", target_data$measure)-1)

# This block calculates the average of each measurement per subject
values_by_subject <- target_data %>%
	group_by(subject, measure, axis) %>%
		summarise(mean(value))

# This block calculates the average of each measurement per activity
values_by_activity <- target_data %>%
	group_by(activityName, measure, axis) %>%
		summarise(mean(value))