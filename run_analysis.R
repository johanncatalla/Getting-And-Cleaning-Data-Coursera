# Load required library
library(dplyr)

# Create a directory to store data if it doesn't already exist
if (!dir.exists("./data_cleaning_project")) {
  dir.create("./data_cleaning_project")
}

# Define download URL and download dataset
dataset_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataset_url, destfile = "./data_cleaning_project/raw_dataset.zip")

# Unzip the dataset
unzip(zipfile = "./data_cleaning_project/raw_dataset.zip", exdir = "./data_cleaning_project")

# === STEP 1: Combine Training and Test Sets ===

# Load training components
features_train <- read.table("./data_cleaning_project/UCI HAR Dataset/train/X_train.txt")
labels_train <- read.table("./data_cleaning_project/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data_cleaning_project/UCI HAR Dataset/train/subject_train.txt")

# Load test components
features_test <- read.table("./data_cleaning_project/UCI HAR Dataset/test/X_test.txt")
labels_test <- read.table("./data_cleaning_project/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data_cleaning_project/UCI HAR Dataset/test/subject_test.txt")

# Load metadata
feature_names <- read.table("./data_cleaning_project/UCI HAR Dataset/features.txt")
activity_lookup <- read.table("./data_cleaning_project/UCI HAR Dataset/activity_labels.txt")
colnames(activity_lookup) <- c("activityID", "activityName")

# Label columns
colnames(features_train) <- feature_names[, 2]
colnames(labels_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(features_test) <- feature_names[, 2]
colnames(labels_test) <- "activityID"
colnames(subject_test) <- "subjectID"

# Merge individual datasets
merged_train <- cbind(labels_train, subject_train, features_train)
merged_test <- cbind(labels_test, subject_test, features_test)
combined_data <- rbind(merged_train, merged_test)

# === STEP 2: Select Mean and Standard Deviation Measurements ===

columns_to_keep <- grepl("activityID|subjectID|mean\\(\\)|std\\(\\)", names(combined_data))
filtered_data <- combined_data[, columns_to_keep]

# === STEP 3: Attach Descriptive Activity Names ===

descriptive_data <- merge(filtered_data, activity_lookup, by = "activityID", all.x = TRUE)

# === STEP 4: Refine Variable Names ===

names(descriptive_data) <- gsub("^t", "time", names(descriptive_data))
names(descriptive_data) <- gsub("^f", "frequency", names(descriptive_data))
names(descriptive_data) <- gsub("Acc", "Accelerometer", names(descriptive_data))
names(descriptive_data) <- gsub("Gyro", "Gyroscope", names(descriptive_data))
names(descriptive_data) <- gsub("Mag", "Magnitude", names(descriptive_data))
names(descriptive_data) <- gsub("BodyBody", "Body", names(descriptive_data))

# === STEP 5: Create Tidy Dataset with Averages ===

final_tidy_data <- descriptive_data %>%
  group_by(subjectID, activityID, activityName) %>%
  summarise_all(mean)

# Save the tidy dataset
write.table(final_tidy_data, "tidy.txt", row.names = FALSE)