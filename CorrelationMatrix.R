#Loaded Libraries
library(readr)
library(corrplot)
#Load in Data from GitHub 
MyData <- read.csv("DataSynth_expand_tag.csv")
NumericDat <- MyData[ , sapply(MyData, is.numeric)]
#Creating correlation matrix 
CorMatrix <- cor(NumericDat, use = "pairwise.complete.obs")
#Viewing correlation matrix 
print(CorMatrix)
# Plot the correlation matrix
corrplot(CorMatrix, method = "color", type = "upper", tl.cex = 0.8)
#Creating a table 
CorTable <- as.data.frame(CorMatrix)
print(CorTable)