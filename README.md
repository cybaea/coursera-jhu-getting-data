# Getting and Cleaning Data Course Project

This is the respository for the course project to the Cousera [Getting and Cleaning Data](https://www.coursera.org/learn/data-cleaning/home/welcome) course.

The files required to complete the project are:

* [README.md](README.md): this overview file.

* [run_analysis.R](run_analysis.R): the R script that runs all fo the analysis to create the tidy data set.

* [CodeBook.md](CodeBook.md): the description of the tidy data.

(It is a big shame that we are not allowed to combine the R script and the CodeBook into one single R Markdown file. But we follow the instructions here.)

## Study Design

The original data is from [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) at the UCI Machine Learning Repository.

For the purposes of this project, we are using a version of the data provided by the instructor at [UCI HAR Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

Note that we have no information about what selection or processing the lecturer applied to the original UCI data to create the dataset we are using. This is not something we have investigated.

## Running the code

Simply run the script `run_analysis.R` to produce the tidy dataset in the file [tidy_data.txt](tidy_data.txt). Re-running the script will overwrite this file.

The tidy data is described in the [CodeBook.md](CodeBook.md) file.

Note that this script connects to the internet to download the datafile if (and only if) a file named `UCI HAR Dataset.zip` is not present in the current directory. In normal usage this means the file is only downloaded once from the internet.

