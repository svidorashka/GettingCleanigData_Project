GettingCleanigData_Project
==========================
The following document describes the steps taken to address questions in the course project.

1. Manually download from the link below:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

2. Manually unzip to a local folder 

3. Load common descriptors of the data for both train and test sets
   3.a FeaturesList, to name the 561 features
   3.b ActivityLabels, for meaningful names of the activities performed by subjects

4. Load the test and train data, while using the FeaturesList from step 3.a to appropriately name the columns

5. Load List of Subjects in Train and Test Set

6. Load the Training and the Test Labels

Start combining the data elements:
7. Join the Train and Test labels with ActivityLabels to have meaningful names of the activities performed by subjects. In order to preserve the order of the records, we add additional column with row indices. After the join we can sort by this column to revert to original order

8. Finally combine all the data from the training and the test set, by binding the subjects, activities and variables vertically, followed by vertical binding of the test and training sets. In the end remove extra unneeded columns - the row index and the activity label

###############
The steps above produce the tidy combined data set with meaningful variable names, as well as meaningful activity names instead of numeric labels. This addresses questions 1, 3 and 4

9. Identify the columns that carry summary statistics - mean and std, but not meanFreq, as it was described differently in the data codebook. Then subset the tidy data table to include only the subjects, activities and the identified list of columns


############### 
The step above produced the reduced combined data set with meaningful variable names, as well as meaningful activity names instead of numeric labels. This addresses question 2

10. summarize the tidy data to make the reduced tidy data table with all the variable means for all combination of subject and activity. 

############### 
This final step produces the final summarized tidy data table, which we write into a csv




