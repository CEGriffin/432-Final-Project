library(dplyr)

#loading the raw_data.csv from Github
plantData<-read.table("https://raw.githubusercontent.com/CEGriffin/432-Final-Project/main/raw_data.csv", 
                            header=T, sep="," )
head(plantData)

plantDecide<-plantData %>%
  select(-c("population", "ID", "gh_bench", "gh_col", "gh_row", "Sample", 
            "Row_Field", "Col_Field", "petri_dish", "family", "Tag"))

plantDecideQ<-subset(plantDecide, common_garden == "Q")
plantDecideN<-subset(plantDecide, common_garden == "N")
plantDecideV<-subset(plantDecide, common_garden == "V")

plantDecide<- rbind(plantDecideQ, plantDecideN, plantDecideV)

plantDecide<- subset(plantDecide, mortality == 1)

plantDecide<- plantDecide %>%
  select(-mortality)

#plantData$population<-as.factor(plantData$population)
plantDecide$common_garden<-as.factor(plantDecide$common_garden)

plantTemp<- plantDecide %>%
  select(-c("common_garden"))

str(plantTemp)

plantTemp$Larg_Leaf_Len_Bolt <- as.numeric(plantTemp$Larg_Leaf_Len_Bolt)
plantTemp$Larg_Leaf_Wid_Bolt <- as.numeric(plantTemp$Larg_Leaf_Wid_Bolt)
plantTemp$GM_StemHeight_Bolt <- as.numeric(plantTemp$GM_StemHeight_Bolt)
plantTemp$GM_Leaf_Number_Bolt <- as.numeric(plantTemp$GM_Leaf_Number_Bolt)

plant_matrix<-as.matrix(plantTemp)

#checking covariance
cov(plantTemp)

#separating into testing and training datasets

train<-c(1:nrow(plantDecide)) %% 2
plantTrain<-plantDecide[train == 1,]

test<-1-train
plantTest<-plantDecide[test == 1,]

library(tree)
plantTree<- tree(common_garden ~ ., data=plantTrain)

#plot the tree with text
plot(plantTree) 
text(plantTree, cex =0.8)

#setting up confusion matrix
plantConfuse<-data.frame(Obs=plantTest$common_garden,Pred=predict(plantTree, plantTest, type="class"))
table(plantConfuse)

#calculating the misclassification rate 
MisClass<-plantConfuse %>%
  filter(Obs!=Pred)
nrow(MisClass)/nrow(plantConfuse)

#checking that misclass and correct class = 1
correct<-plantConfuse %>%
  filter(Obs==Pred)
nrow(correct)/nrow(plantConfuse)

#sum does in fact equal 1



























