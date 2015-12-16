####Data Wrangling Project

This project was aimed to practice with data wrangling techniques. The data used was provided by Smartlab, 
and includes various measurements taken over the course of a day by the sensors in a Galaxy S Smartphone. 
Each observation was tied to a certain activity that the test subject happened to be engaging in at the time the 
measurement was taken (walking, sitting, laying down, etc.).

A full description of the data can be found inside README_Smartlab.txt.

#The objectives were the following:

- Merge the training and test data sets
- Extract the columns containing the mean and standard deviation for each measurement
- Label all observations with the associated activity label, activity name, and test subject
- Create the following two data sets:
	1. Average of each measurement for each activity type
	2. Average of each measurement for each test subject

These tasks were accomplished in the run_analysis.R script. All other files contain the various data needed for 
analysis