#Read data into R
read.table("ASS3/UCI HAR Dataset/test/subject_test.txt")->subject_test
read.table("ASS3/UCI HAR Dataset/test/X_test.txt")->x_test
read.table("ASS3/UCI HAR Dataset/test/y_test.txt")->y_test
read.table("ASS3/UCI HAR Dataset/train/subject_train.txt")->subject_train
read.table("ASS3/UCI HAR Dataset/train/X_train.txt")->x_train
read.table("ASS3/UCI HAR Dataset/train/y_train.txt")->y_train
read.table("ASS3/UCI HAR Dataset/features.txt")->features

#Name the variables, add subject and activity to the table 
features[[2]]->names(x_test)
features[[2]]->names(x_train)
"Activity"->names(y_test)
"Activity"->names(y_train)
"Subject"->names(subject_test)
"Subject"->names(subject_train)

#Merge test and train data
cbind(subject_test,y_test,x_test)->test
cbind(subject_train,y_train,x_train)->train
rbind(test,train)->all
all[order(all[[1]],all[[2]]),]->all_

#Identify mean and standard deviation
grep("mean()",features[[2]],fixed=TRUE)->a
grep("std()",features[[2]],fixed=TRUE)->b
all_[,c(1:2,sort(c(a,b))+2)]->all_

#Name activities
for(i in 1:length(all_[[2]])){
  if(all_[i,2]==1){all_[i,2]="WALKING"}
  if(all_[i,2]==2){all_[i,2]="WALKING_UPSTAIRS"}
  if(all_[i,2]==3){all_[i,2]="WALKING_DOWNSTAIRS"}
  if(all_[i,2]==4){all_[i,2]="SITTING"}
  if(all_[i,2]==5){all_[i,2]="STANDING"}
  if(all_[i,2]==6){all_[i,2]="LAYING"}
}

#Summary(It should have a better method)
library(reshape2)
outcome=data.frame()
split(all_,all_$Subject)->c
for(j in 1:30){
  melt(c[[j]],"Activity",names(c[[j]])[3:length(names(c[[j]]))])->cc
  dcast(cc,Activity~variable,mean)->ccc
  cbind(rep(j,6),ccc)->cccc
  rbind(outcome,cccc)->outcome
}
"Subject"->names(outcome)[1]
for(k in 3:length(names(outcome))){
  paste("averge-",names(outcome)[k],sep="")->names(outcome)[k]
}
outcome
