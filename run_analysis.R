setwd("C:/Users/Diego/Documents/Cosas utiles de R/UCI HAR Dataset")



features<-read.table("./features.txt",sep = " ")

subject_test<-read.table("./test/subject_test.txt")
x_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/y_test.txt")

subject_train<-read.table("./train/subject_train.txt")
x_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt")

#Merges the training and the test sets to create one data set.
data<-rbind(x_test,x_train)

#Extracts only the measurements on the mean and standard deviation for each measurement.

means<-colMeans(data)

estandardev<-sapply(data,sd)

#Uses descriptive activity names to name the activities in the data set

name<-c("WALKING","WALKING_UPSTAIRS" ,"WALKING_DOWNSTAIRS"
        ,"SITTING","STANDING","LAYING")

y_test<-sapply(y_test,function(x){name[x]})
y_train<-sapply(y_train,function(x){name[x]})

y_test<-apply(cbind(subject_test,y_test),1,paste,collapse=".")

y_train<-apply(cbind(subject_train,y_train),1,paste,collapse=".")


colnames(x_test)<-features[,2]
colnames(x_train)<-features[,2]



test<-cbind(y_test,x_test)
train<-cbind(y_train,x_train)

colnames(test)[1]<-"subject.activity"
colnames(train)[1]<-"subject.activity"


data<-rbind(test,train)

#Appropriately labels the data set with descriptive variable names

colnames(data)<-gsub("-","",colnames(data))
colnames(data)<-gsub("\\()","",colnames(data))

colnames(data)<-sub("t","original.",colnames(data))
colnames(data)<-sub("Acc",".acceleration.",colnames(data))
colnames(data)<-sub("Gyro","angular.velocity.",colnames(data))
colnames(data)<-sub("Mag",".magnitude.",colnames(data))
colnames(data)<-sub("f","fourier.transform.",colnames(data))
colnames(data)[1]<-"subject.activity"


#Columnas repetidas
dup<-duplicated(colnames(data))
n<-length(colnames(data)[dup])
colnames(data)[dup]<- paste(colnames(data)[dup],seq(1:n))



grouped<-split(data,data$subject.activity)

tidytablesd<-sapply(grouped,FUN = function(x)sapply(x[,-1],sd))
tidytablemean<-sapply(grouped,FUN = function(x)colMeans(x[,-1]))
setwd("C:/Users/Diego/Documents/Cosas utiles de R")
tidytablemean<-t(tidytablemean)
write.table(tidytablemean,"./tidydata.txt",row.name=FALSE)
