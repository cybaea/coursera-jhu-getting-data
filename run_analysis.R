## run_analysis.R - main script for Getting and Cleaning Data Course Project

## Author: Allan Engelhardt

## This is the course project for the Getting and Cleaning Data course available
## at Coursera: https://www.coursera.org/learn/data-cleaning/home/welcome.
##
## This script does the following (from the course description):
##
## 1. Merges the training and the test sets to create one data set.
##
## 2. Extracts only the measurements on the mean and standard deviation for each
## measurement.
##
## 3. Uses descriptive activity names to name the activities in the data set
##
## 4. Appropriately labels the data set with descriptive variable names.
##
## 5. From the data set in step 4, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject.

## ====================================================================
## NOTE THAT WE USE THE tidyverse FUNCTIONS CONSISTENTLY THROUGHOUT
## while the course uses a mixture of base R, data.table, and an old
## version of tidyverse (plyr/dplyr).

library("tidyverse")

## NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE
## ====================================================================




## ============================================================
## Download the data to local storage if it isn't there already

data_url <- 
  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data_file <- "UCI HAR Dataset.zip"

if (!file.exists(data_file)) {
  ## Grab the zip file
  status <- download.file(data_url, data_file, method = "curl", quiet = TRUE)
  if (status != 0) {
    stop("Could not download data")
  }
}

## Unzip it
unzip(data_file, setTimes = TRUE)

## ============================================================



## ============================================================
## Load and merge the data sets.
## Note that we only need the mean and standard deviation measurements.

## First get the names of the features

features <-
  read_delim(
    file = "UCI HAR Dataset/features.txt",
    delim = " ",
    col_names = c("column_number", "feature_name"),
    col_types = "ic"  # integer, character
  )

## Feature names from the file are hard to use as column names, so let's make
## syntactivally valid names. We can tidy them up later. We only need means
## [-mean()-] and standard deviations [-std()-] so we mark them.

features <-
  features %>% 
  mutate(is_needed = str_detect(feature_name, "-(mean|std)\\(\\)")) %>% 
  ## Base R function makes better names
  mutate(feature_column = make.names(feature_name, unique = TRUE)) %>%
  ## Tidyverse style guide prefers _ to . so we change it here:
  mutate(feature_column = str_replace_all(feature_column, "\\.+", "_"))


## Get the activity labels (as factors)

activity_labels <-
  read_delim(
    file = "UCI HAR Dataset/activity_labels.txt",
    delim = " ",
    col_names = c("id", "activity"),
    col_types = "if"  # integer, factor
  )

## DRY - Don't Repeat Yourself. So we make a function here to read the files
## from either train or test and return the tibble (data.frame)

read_from_directory <- function(directory, prefix = "UCI HAR Dataset") {
  
  ## Test arguments
  stopifnot(is.character(directory))
  stopifnot(nchar(directory) > 0)
  directory_path <- file.path(prefix, directory)
  if (!dir.exists(directory_path)) {
    stop("Directory ", directory_path, " not found.")
  }
  
  ## Now read the data set. Use features as column names and read data as
  ## numeric ("n") type which handles scientific notation for us. Skipping columns
  ## using "-" or "_" doesn't seem to work right in this version of tidyverse so
  ## we fix the columns after reading them all.
  
  data_set <-
    read_delim(
      file = file.path(directory_path, str_c("X_", directory, ".txt")),
      delim = " ",
      col_names = features$feature_column,
      col_types = strrep("n", NROW(features))
    ) %>%
    select(one_of(features %>%
                    filter(is_needed) %>%
                    pull(feature_column)))
  
  ## We read the activity. The file y_train.txt is a single vector, one element
  ## for each observation in the training data. Here read_delim() is over-kill,
  ## but we keep it for future compatibility, should the files acquire more
  ## columns.
  
  activity <-
    read_delim(
      file = file.path(directory_path, str_c("y_", directory, ".txt")),
      delim = " ",
      col_names = "id",
      col_types = "n"
    ) %>%
    ## We add the labels
    left_join(activity_labels, by = "id")
  
  ## We add the factor to the start of the training_set. The function cbind()
  ## from base R would work, but we use the equivalent from the tidyverse.
  
  data_set <- bind_cols(activity[,-1], data_set)
  
  ## It is the same for the subject id.
  
  subject <-
    read_delim(
      file = file.path(directory_path, str_c("subject_", directory, ".txt")),
      delim = " ",
      col_names = "subject",
      col_types = "i"
    )
  data_set <- bind_cols(subject, data_set)
  data_set %>% 
    mutate(data_set = directory) %>% 
    select(data_set, everything())
}

training_data <- read_from_directory("train")
test_data <- read_from_directory("test")
stopifnot(NCOL(training_data) == NCOL(test_data))
data <- bind_rows(training_data, test_data)

## Now tidy the data set. Note that the cast/melt functions mentioned in the
## course were replaced by gather/spread as tidyverse (dplyr) matured and these
## have in turn recently been replaced by pivot_longer/pivot_wider. The fun of
## keeping up with developments in R...!

tidy_data <-
  data %>% 
  pivot_longer(
    -c(data_set, subject, activity),
    names_to = c("sensor", "measure", "dimension"),
    names_sep = "_"
  ) %>% 
  ## Let's convert the characters to factors for convenience.
  mutate_if(is.character, as_factor) %>% 
  ## Sort the data in a sensible way
  arrange(data_set, subject, activity, sensor, measure, dimension)

write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)

## "From the data set in step 4, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject."

submit_data <-
  tidy_data %>% 
  group_by(subject, activity, sensor, measure, dimension) %>% 
  summarise(mean = mean(value), n = n())

## Save the data

write.table(submit_data, file = "submit_data.txt", row.names = FALSE)

## ============================================================
