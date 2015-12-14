library(tidyr)
library(dplyr)

train_features <- read.table("train/X_train.txt")
test_features <- read.table("test/X_test.txt")
combined_data <- rbind(train_features, test_features)

column_names <- scan(file = "features.txt", what = "character", sep = "\n")
column_names <- sub("^[0-9]* ", "", column_names)
colnames(combined_data) <- make.names(column_names, unique = TRUE, allow_ = TRUE)

target_data <- select(combined_data, matches("mean|std"))
target_data <- tbl_df(target_data)

train_labels <- scan("train/y_train.txt")
test_labels <- scan("test/y_test.txt")
combined_labels <- c(train_labels, test_labels)
target_data$ActivityLabel <- combined_labels

activity_labels <- read.table("activity_labels.txt")[[2]]
target_data$ActivityName <- activity_labels[target_data$ActivityLabel]

target_data$id <- c(1:nrow(target_data))
target_data <- target_data %>%
	gather(measure, value, -id, -ActivityLabel, -ActivityName)

target_data$axis <- ifelse(grepl("...X", target_data$measure), "x", ifelse(grepl("...Y", target_data$measure), "y", "z"))
target_data$stat <- ifelse(grepl("[a-zA-Z]*.mean", target_data$measure), "mean", "std")
target_data$measure <- substr(target_data$measure, 1, regexpr("\\.", target_data$measure)-1)

