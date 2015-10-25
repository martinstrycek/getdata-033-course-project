script.dir <- dirname(sys.frame(1)$ofile)
setwd(script.dir)

dataZip <- 'getdata_projectfiles_UCI_HAR_Dataset.zip'
if (!file.exists(dataZip)){
  download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', dataZip)
  unzip(dataZip)
}

setwd(paste(script.dir,'/UCI HAR Dataset/test/', sep=""))
testX <- read.table('X_test.txt')
testY <- read.table('y_test.txt')
testSubject <- read.table('subject_test.txt')

setwd(paste(script.dir,'/UCI HAR Dataset/train/', sep=""))
trainX <- read.table('X_train.txt')
trainY <- read.table('y_train.txt')
trainSubject <- read.table('subject_train.txt')

setwd(paste(script.dir,'/UCI HAR Dataset/', sep=""))
activityLabels <- read.table('activity_labels.txt',header=FALSE)

features <- read.table('features.txt',header=FALSE)
features[,2] <- as.character(features[,2])
featuresToKeep <- grep("-(mean|std)\\(\\)", features[, 2])
featuresToKeep.names <- features[featuresToKeep,2]

train <- cbind(trainSubject, trainY, trainX[featuresToKeep])
test <- cbind(testSubject, testY, testX[featuresToKeep])

allData <- rbind(train, test)
colnames(allData) <- c("Subject", "Activity", featuresToKeep.names)

allData$Activity <- factor(allData$Activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$Subject <- as.factor(allData$Subject)

allData.melted <- melt(allData, id = c("Subject", "Activity"))
allData.mean <- dcast(allData.melted, Subject + Activity ~ variable, mean)

write.table(allData.mean, "../tidy.txt", row.names = FALSE, quote = FALSE)