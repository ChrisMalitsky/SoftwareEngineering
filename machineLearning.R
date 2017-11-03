######################################################################################

#Had to run the following command on each library#
install.packages('dplyr')
install.packages('caret')
install.packages('rattle')
install.packages('ggplot2')
install.packages('rpart')
install.packages('rpart.plot')
install.packages('knitr')
install.packages('e1071', dependencies=TRUE)
install.packages("randomForest")
install.packages('Rborist')

#Then installed each library
library(dplyr)
library(caret)
library(rattle)
library(ggplot2)
library(rpart)
library(rpart.plot)
library(knitr)
library(e1071)
library(randomForest)
library(Rborist)

######################################################################################
#After importing all of the packages, the following code can be run
######################################################################################

#data gets the csv file
data <- read.csv("/Users/christophermyers/Desktop/School/SWEng/data.txt", sep=",", dec=".")
data <- select(data, -(19:20))

#Prints out the data object
# Reference: str: https://www.rdocumentation.org/packages/utils/versions/3.4.1/topics/str
str(data)

# The mutatue function adds new columns to the matrix
# Reference: mutate: https://www.rdocumentation.org/packages/dplyr/versions/0.5.0/topics/mutate
data <- mutate(data, V19=1, V20=1)

# The following for loops go through each decay coefficient and determine if it is good or bad
# by comparing every coefficient to the average coefficient

#Compressor loops
for(i in 1:nrow(data)){
  if (data[i,17] >= mean(data$Compressor.decay)) { 
    data[i,19]="Compressor_E"
  }else{
    data[i,19]="Compressor_Non"
  }
}

#Turbine loops
for(i in 1:nrow(data)){
  if (data[i,18] >= mean(data$Turbine.decay)){ 
    data[i,20]="Turbine_E"
  }else{
    data[i,20]="Turbine_Non"
  }
}

# The method as.factor turns entries into categorical variables
# Reference: as.factor:https://www.rdocumentation.org/packages/h2o/versions/3.10.5.3/topics/as.factor
# More on Factors in R: https://www.rdocumentation.org/packages/base/versions/3.4.1/topics/factor
data$V19 <- as.factor(data$V19)
data$V20 <- as.factor(data$V20)
data <- select(data, -Turbine.decay, -Compressor.decay, -Lever.Position)

#Eliminates variables that are null
data <- data[, colSums(is.na(data))==0]

# The method nearZeroVar "diagnoses predictors that have one unique value (i.e. are zero variance predictors) or predictors 
# that are have both of the following characteristics: they have very few unique values relative to the number of samples and 
# the ratio of the frequency of the most common value to the frequency of the second most common value is large."
# Reference: nearZeroVar: https://www.rdocumentation.org/packages/caret/versions/6.0-77/topics/nearZeroVar
nzv <- nearZeroVar(data[, -(16:17)], saveMetrics = TRUE)
data <- data[, nzv$nzv==FALSE]

# The method findCorrelation will see if two variable vectors have anything in common
# Reference: findCorrelation: https://www.rdocumentation.org/packages/caret/versions/6.0-77/topics/findCorrelation
corrM <- cor(data[,-(14:15)])
high <- findCorrelation(corrM, cutoff = .95)
data <- data[, -high]

# createDataPartition splits the data, in this case 70/30, into training and testing data
# 70% for training
# 30% for testing
# Reference: createDataPartition: https://www.rdocumentation.org/packages/caret/versions/6.0-77/topics/createDataPartition
set.seed(1000)
inTrain <- createDataPartition(data$V19, p=0.7, list=FALSE)
training <- data[inTrain,]
testing <- data[-inTrain,]

#####Models for Compressor Decay#####

# Uses the method rpart to train training data
modFit_C <- train(V19~., method="rpart", data=training)
modFit_C

# Prints out statistical information regarding the trained data
print(modFit_C$finalModel)

# Creates a confusion matrix which has the characteristics:
# How many Good coefficients vs how many bad coefficients
# predicted vs reference for each the good and bad coefficient
# Displays how accurate this testing was
predictions_C <- predict(modFit_C, newdata = testing)
confusionMatrix(predictions_C, testing$V19)

# Produces a decision tree
cart <- rpart(V19~., data=training, method="class")
prp(cart)

# Displays a graph of the most important variables
Varimpcompr <- varImp(modFit_C, scale=TRUE)
plot(Varimpcompr, main="Critical Variables for the Compressor Delay")

#####Models for the Turbine Decay#####

# Uses the method rpart to train training data
modFit_T <- train(V20~., method="rpart", data=training)
modFit_T

# Prints out statistical information regarding the trained data
print(modFit_T$finalModel)

# Creates a confusion matrix which has the characteristics:
# How many Good coefficients vs how many bad coefficients
# predicted vs reference for each the good and bad coefficient
# Displays how accurate this testing was
predictions_T <- predict(modFit_T, newdata=testing)
confusionMatrix(predictions_T, testing$V20)

# Produces a decision tree
cart <- rpart(V20~., data=training, method="class")
prp(cart)

# Displays a graph of the most important variables
Varimpturb <- varImp(modFit_T, scale=TRUE)
plot(Varimpturb, main = "Critical Variables for the Turbine Decay")

###############################################################################
####################Testing Random Forest On V20###############################

modFit_RF <- train(V20~., method="rf", data = training)
modFit_RF

print(modFit_RF$finalModel)

predictions_RF <- predict(modFit_RF, newdata=testing)
confusionMatrix(predictions_RF, testing$V20)

varimp <- varImp(modFit_RF, scale = FALSE)
plot(varimp, main="Most Important Variables")

head(getTree(modFit_RF$finalModel, k=2))

pred <- testing$V20
table(pred, testing$V20)

###############################################################
