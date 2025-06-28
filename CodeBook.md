# CodeBook.md – Data Cleaning and Tidy Dataset Creation

This CodeBook documents the transformation and cleaning processes performed on the Human Activity Recognition Using Smartphones Dataset using R. It includes details about the original data, processing steps from the `run_analysis.R` script, and descriptions of the resulting tidy dataset.

## Data Access and Preparation

### Downloading and Unzipping

- The dataset was retrieved from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
- A directory named `data_cleaning_project` is automatically created if it doesn’t exist.
- The dataset is downloaded as a ZIP file and extracted into the same directory for further processing.

### Data Components

After unzipping, the following files are used:

- `features.txt`: 561 feature labels.
- `activity_labels.txt`: Descriptive names for 6 activity codes.
- `train/` and `test/` subfolders containing:
  - `X_train.txt`, `X_test.txt`: Sensor measurements.
  - `y_train.txt`, `y_test.txt`: Activity labels.
  - `subject_train.txt`, `subject_test.txt`: Subject IDs.

## Data Processing Workflow

The following summarizes the 5-step processing pipeline implemented in `run_analysis.R`:

### STEP 1: Merging Training and Test Sets

- Read all relevant data files.
- Assign clear column names using `features.txt` and manual naming for subject and activity columns.
- Combine subject, activity, and measurement datasets using `cbind()`.
- Merge training and test datasets using `rbind()` to create a complete dataset with 10,299 rows and 563 columns.

### STEP 2: Extracting Mean and Standard Deviation Measurements

- Filter the merged dataset to retain only variables that represent means (`mean()`) or standard deviations (`std()`), as well as subject and activity identifiers.
- This results in a subset of 88 relevant features.

### STEP 3: Applying Descriptive Activity Names

- Join the filtered data with `activity_labels.txt` to map each activity code (`activityID`) to a descriptive activity name (`activityName`).

### STEP 4: Labeling Data with Descriptive Variable Names

- Clean and enhance variable names using a series of `gsub()` replacements:
  - `t` → `time`
  - `f` → `frequency`
  - `Acc` → `Accelerometer`
  - `Gyro` → `Gyroscope`
  - `Mag` → `Magnitude`
  - `BodyBody` → `Body`
- This makes variable names self-descriptive and readable.

### STEP 5: Creating a Second, Independent Tidy Dataset

- Group the data by `subjectID`, `activityID`, and `activityName`.
- Calculate the average of each remaining variable.
- Output: a tidy dataset with 180 rows and 88 columns, saved as `tidy.txt`.

## Variable Glossary

| Variable | Description |
|----------|-------------|
| `subjectID` | Unique identifier for each subject (1 to 30) |
| `activityID` | Activity code (1 to 6) |
| `activityName` | Descriptive name of activity (e.g., WALKING, SITTING) |
| `timeBodyAccelerometerMeanX`, `frequencyBodyGyroscopeStdZ`, etc. | Processed features from accelerometer and gyroscope signals, measuring either mean or standard deviation along X, Y, or Z axes |

All feature names follow a consistent format, indicating:
- Signal type (`time` or `frequency`)
- Sensor (`BodyAccelerometer`, `BodyGyroscope`, etc.)
- Function applied (`Mean` or `Std`)
- Axis (if applicable: `X`, `Y`, `Z`)

## Notes

- The dataset used was pre-collected and made public by Samsung.
- Data transformations strictly followed the Coursera Getting and Cleaning Data course project requirements.
- The final output is a tidy dataset ready for statistical modeling or machine learning tasks.

## Output Files

| File | Purpose |
|------|---------|
| `tidy.txt` | Final tidy dataset containing average values for each measurement per subject-activity pair |
| `run_analysis.R` | Main R script that executes all processing steps from data import to tidy data export |
