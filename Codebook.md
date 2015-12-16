#Codebook
run_analysis.R

##Data

###Procedures
The data for this project are spread out over a variety of files. When put together, the resulting data
form a data frame resembling the below:

**Table 1**
|================|===============|=========|================|================|=====|
| activity.label | activity.name | subject | measureA-std-X | measureA-std-Y | ... |
|================|===============|=========|================|================|=====|
|                |               |         |                |                |     |
|                |               |         |                |                |     |             
|                |               |         |                |                |     |             
|                |               |         |                |                |     |             
|================|===============|=========|================|================|=====|

The vast majority of the column names contained three variables:
	1. The measurement being examined
	2. Whether the value represents the mean or standard deviation of the measurement during the observation 
	window. A wealth of additional statistics were available in the data, but this project only examines the
	mean and standard deviation of each measurement.
	3. The spatial axis along which the observation was made.

	E.G. 	measureA-std-X means that the value represents the standard deviation of measurementA along 
			the X axis

In order to tidy the data, these three variables needed to be separated. The tidy data set is of
the following form:

**Table 2**
|================|===============|=========|====|=========|=======|======|======|
| activity.label | activity.name | subject | id | measure | value | axis | stat |
|================|===============|=========|====|=========|=======|======|======|
|                |               |         |    |         |       |      |      |
|                |               |         |    |         |       |      |      |
|                |               |         |    |         |       |      |      |
|                |               |         |    |         |       |      |      |
|================|===============|=========|====|=========|=======|======|======|

This separates the three variables into their own columns. 'id' was included as a reference to the original
row of the original data. This is to provide the ability to construct a group of measurements from a specific
range of time as that is what a row in the original data corresponds to.

The data was cleaned in the following manner:

First, all of the columns were accumulated from the various files where they are located. A more detailed 
description of the data files can be found later. Each file in both the training and test data are structured
such that each row in one file corresponds to the same row in the other files. As a result, all of the data was 
combined before running any transformation functions. 

Once all of the data was combined into one data frame, the tidyr gather() function was run to create a measure 
column. The values of the measure column are the original column names containing the measurement, stat, and 
axis. 

Since the data are in a long format instead of the wide format it was originally presented in, the axis and stat
columns can be created. If the value inside the measure column contained '-X', then that means the 
measurement was taken along the x axis, so 'x' should be written to the axis column. Similarly, if the 
measure column contained '-std', then the measurement represented a standard deviation, so 'std' should be 
written to the stat column. Once those columns were populated, a short substring replace function cleaned
the values in the measure column by eliminating the axis and stat data.

With the data in a tidy format, scripts were run to extract more meaningful information. The average of each
measurement was taken per test subject and per activity type.

###Data Files
* **test/subject_test.txt:**
	The test subject for each measurement taken in the test data

* **test/X_test.txt:**
	The measurements for the test data

* **test/y_test.txt:**
	The activity corresponding to each measurement in the test data

* **train/subject_test.txt:**
	The test subject for each measurement taken in the training data

* **train/X_test.txt:**
	The measurements for the training data

* **train/y_test.txt:**
	The activity corresponding to each measurement in the training data

* **activity_labels.txt:**
	A mapping of activity ids to activity name. E.G. 1 corresponds to walking

* **features.txt:**
	The column names for the different measurements

* **features_info.txt:**
	More detailed description of the various measurements

* **README_Smartlab.txt:**
	The README that came along with all of the data

* **run_analysis.R:**
	The script that cleans the data

##Variables

The following describes the variables in the resulting data set:

* **activity.label:**
	The numeric label of the activity associated to the observation

* **activity.name:**
	The friendly label of the activity associated to the observation

* **subject:**
	The test subject for whom the measurement was made

* **id:**
	The row from the original data set where the observation originated

* **measure:**
	The measurement that was made 

* **value:**
	The observed value of the measurement

* **axis:**
	The spatial axis along which the measurement was made

* **stat:**
	Whether the measurement was a mean or standard deviation


