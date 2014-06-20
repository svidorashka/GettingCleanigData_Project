#The zipped file was manually downloaded from the link below:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#And the data was manually unzipped to a local folder
DataPath<-getwd()

#First, load common descriptors of the data for both train and test sets

#Load names of features. This vector will be used to name the columns of the 561-feature vector
FeaturesList<-{
   read.csv(paste(DataPath, "features.txt",sep = ""), 
   colClasses="character",
   col.names="FeatureName",
   sep = "\n",
   header = FALSE)
   }

#Load the 6 Activity Labels, to have meaningful names of the activities performed by subjects
ActivityLabels<-{
  read.csv(paste(DataPath, "activity_labels.txt",sep = ""), 
  sep = " ",
  col.names=c("ActivityLabel", "Activity"),
  colClasses=c("numeric","character"),
  header = FALSE)
}

#Now load Test and Train Data.
#The following data frames have the same number of rows, corresponding to the number of records

#Load List of Subjects in Train and Test Set: subject who performed the activity for each window sample
Subject_Train<-read.csv(paste(DataPath, "train/subject_train.txt",sep = ""), col.names="SubjectID",header = FALSE)
Subject_Test<-read.csv(paste(DataPath, "test/subject_test.txt",sep = ""), col.names="SubjectID",header = FALSE)

#Load the Training and the Test Data Sets, while using the FeatureName loaded earlier for Column Names
#The Train_X and Test_X are similarly structured
#There is a 561-feature vector with time and frequency domain variables in each record line 
X_Train<-{read.csv(paste(DataPath, "train/X_train.txt",sep = ""),
                    col.names=FeaturesList$FeatureName,
                    sep = "",
                    header = FALSE)
}
X_Test<-{read.csv(paste(DataPath, "test/X_test.txt",sep = ""),
                    col.names=FeaturesList$FeatureName,
                    sep = "",
                    header = FALSE)
}

#Load the Training and the Test Labels
y_Train<-read.csv(paste(DataPath, "train/y_train.txt",sep = ""), col.names="ActivityLabel",header = FALSE)
y_Test<-read.csv(paste(DataPath, "test/y_test.txt",sep = ""), col.names="ActivityLabel",header = FALSE)

#The merge command will scramble the original order of the data!!
#Will add a row index column and sort by it later to preserve the originl order
y_Train$row.id<-1:nrow(y_Train)
y_Test$row.id<-1:nrow(y_Test)

#Start combining the data elements:
#Join the Train and Test labels with ActivityLabels to have meaningful names of the activities performed by subjects
#We need to preserve the order of the records, in order to bind with other data later
y_Train_wActivity<-merge(y_Train,ActivityLabels,sort=FALSE)
y_Test_wActivity<-merge(y_Test,ActivityLabels,sort=FALSE)

#sort by the row.id to get back the original order
library(plyr)
Train_Activity<- arrange(y_Train_wActivity, row.id)
Test_Activity<- arrange(y_Test_wActivity, row.id)


#Finally combine all the data from the training and the test set
AllDataCombined<-{cbind(rbind(Subject_Train,Subject_Test),
                   rbind(Train_Activity,Test_Activity),
                   rbind(X_Train,X_Test))
                    }
#Remove the labels column, and row.id columns, 
#they're not needed, and this produces the tidy combined data set!
AllDataCombined<-AllDataCombined[,c(-2,-3)]
###############  Questions #1, #3 and #4 are answered above!########################

#Identify the columns that carry summary statistics - mean and std
#Also Identify columns that contain meanFreq
ColumnNames<-names(AllDataCombined)
MeanStd_ColInd <- grep("mean()|std()", ColumnNames)
MeanFreq_ColInd <- grep("meanFreq()", ColumnNames)

#Create a list of columns to keep in the summary data set
#Use columns with mean and std, but not meanFreq. 
#In the same step add the first two columns with subject and activity
FinalColumnsInd<-c(1:2,setdiff(MeanStd_ColInd,MeanFreq_ColInd))

#Subset the data using the final list of columns, and this is the reduced data set!
MeanStd_Data<-AllDataCombined[,FinalColumnsInd]

############### Question #2 is answered above!########################

#summarize the tidy data to make the reduced tidy data table with all the variable means
# for all combination of subject and activity
# and this step produces the final reduced tidy data table!

SmallTidyData <- aggregate(.~SubjectID+Activity, FUN=mean, data=MeanStd_Data)
############### Question #5 is answered above!########################

#write the resulting tidy data set into a csv file
write.csv(SmallTidyData, file = "SmallTidyData.csv",row.names=FALSE)
