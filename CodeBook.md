# Codebook for Getting and Cleaning Data Course Project

This is the code book for the tidy data set created by the [run_analysis.R](run_analysis.R) script for this course project. See the file [README.md](README.md) for documentation of the script and the study design.

The tidy data is written to the file [tidy_data.txt](tidy_data.txt). The format is that produced by [write.table](https://www.rdocumentation.org/packages/utils/versions/3.6.1/topics/write.table) with the `row.names = FALSE` argument.

The data has 7 columns

1.  **data_set**: this containts the value "test" or "train" to show if the data is from the test or training data set, respectively.

2.  **subject**: this is the identifier for the subject under observation. There are 30 subjects numbered from 1 to 30.

3.  **activity**: this contains text desrcibing the type of activity the subject performed. Possible values are WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING,  STANDING, and LAYING.

4.  **sensor**: the code for the sensor metric of the measurement. There are 17 different sensors.

5.  **measure**: indicates if the data is the mean ("mean") or standard deviation ("std"). This data set is a subset of the original data and only contains these two summary statistics.

6.  **dimension**: Many of the sensor metrics have three values, one for each spatial dimention which is denoted by "x", "y", and "z" in this column. The nine 'magnitude' sensors (names ending with "Mag") only provide one value and these have "" in this column.

7.  **value**: this is the measured value.

    * The original data has all values normalised and bounded to [-1,1] and we have not altered the values.
    * The gyroscope ("Gyro") measures angular velocity while the accelerometer provided tri-axial and total acceleration. 
    * In the original data a Fast Fourier Transform (FFT) was applied to some of the signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag.


For more information about the underlying data, see the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) on the UCI Machine Learning Repository.


