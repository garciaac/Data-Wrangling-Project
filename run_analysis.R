library(tidyr)
library(dplyr)

# This block reads the training measurements and the test measurements
# from their respective files, and then combines them into one data frame.
train.features <- read.table("train/X_train.txt")
test.features <- read.table("test/X_test.txt")
combined.data <- rbind(train.features, test.features)

# This block reads the names of the measurements from the features.txt file, and
# makes them the column names for the combined.data variable defined earlier.
column.names <- scan(file = "features.txt", what = "character", sep = "\n")
# Since each line in the file is numbered (e.g. "1 tBodyAcc-mean()-X"), the 
# sub function substitutes the number and space with a blank string effectively
# deleting it.
column.names <- sub("^[0-9]* ", "", column.names)
# make.names transforms the column names into syntactically valid strings.
colnames(combined.data) <- make.names(column.names, unique = TRUE, allow_ = TRUE)

# Only the mean and standard deviation for each measurement are needed.
target.data <- select(combined.data, matches("mean|std"))
target.data <- tbl_df(target.data)

# This block reads in the activity label for each row in the
# training and test data sets and combines them into a new 
# column in target.data.
train.labels <- scan("train/y_train.txt")
test.labels <- scan("test/y_test.txt")
combined.labels <- c(train.labels, test.labels)
target.data$activity.label <- combined.labels

# Similar to the column names, the list of activity names is numbered. The read.table
# function is used, which separates the numbers and labels, and then the column containing
# the labels is selected via subscript.
activity.labels <- read.table("activity_labels.txt")[[2]]
# Creates a new column called activity.name, and then looks up the appropriate
# value based on the corresponding value in the activity.label column.
target.data$activity.name <- activity.labels[target.data$activity.label]

# This block reads the training subject ids and the test subject ids
# from their respective files, and then combines them into one vector.
train.subjects <- scan("train/subject_train.txt")
test.subjects <- scan("test/subject_test.txt")
combined.subjects <- c(train.subjects, test.subjects)
target.data$subject <- combined.subjects

# This creates an id column
target.data$id <- c(1:nrow(target.data))

# This translates the wide data format into the long data format. id, activity.label,
# activity.name, and subject are all excluded because they are variables.
target.data <- target.data %>%
	gather(measure, value, -id, -activity.label, -activity.name, -subject)

# This block creates the axis and stat variables. The values depend on the value inside
# measure column created by gather(). 
target.data$axis <- ifelse(grepl("...X", target.data$measure), "x", ifelse(grepl("...Y", target.data$measure), "y", "z"))
target.data$stat <- ifelse(grepl("[a-zA-Z]*.mean", target.data$measure), "mean", "std")
# Once the data is parsed, this function cleans up the values in the measure column by eliminating
# the axis and stat information from it.
target.data$measure <- substr(target.data$measure, 1, regexpr("\\.", target.data$measure)-1)

# This block calculates the average of each measurement per subject
values.by.subject <- target.data %>%
	group_by(subject, measure, axis) %>%
		summarise(mean(value))

# This block calculates the average of each measurement per activity
values.by.activity <- target.data %>%
	group_by(activity.name, measure, axis) %>%
		summarise(mean(value))