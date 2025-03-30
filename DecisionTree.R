library(dplyr)
library(tree)

#loading the raw_data.csv from Github
plantData<-read.table("https://raw.githubusercontent.com/CEGriffin/432-Final-Project/main/raw_data.csv", 
                            header=T, sep="," )
head(plantData)

## Not Down Sampled Decision Tree without Bolt Data

plantDecide_raw<-plantData %>%
  select(-c("population", "ID", "gh_bench", "gh_col", "gh_row", 
            "Row_Field", "Col_Field", "petri_dish", "family", "Tag"))

plantDecideQ<-subset(plantDecide_raw, common_garden == "Q")
plantDecideN<-subset(plantDecide_raw, common_garden == "N")
plantDecideV<-subset(plantDecide_raw, common_garden == "V")

plantDecide_raw<- rbind(plantDecideQ, plantDecideN, plantDecideV)

plantDecide<-plantDecide_raw %>%
  select(-c("Larg_Leaf_Len_Bolt", "Larg_Leaf_Wid_Bolt", "GM_StemHeight_Bolt", "GM_Leaf_Number_Bolt"))

#plantData$population<-as.factor(plantData$population)
plantDecide$common_garden<-as.factor(plantDecide$common_garden)

plantTemp<- plantDecide %>%
  select(-c("common_garden"))

str(plantTemp)

plant_matrix<-as.matrix(plantTemp)

#checking covariance
cov(plantTemp)

#separating into testing and training datasets

train<-c(1:nrow(plantDecide)) %% 2
plantTrain<-plantDecide[train == 1,]

test<-1-train
plantTest<-plantDecide[test == 1,]

plantTree<- tree(common_garden ~ ., data=plantTrain)

#plot the tree with text
plot(plantTree) 
text(plantTree, cex =0.8)

#prune nodes
pruneTree<-cv.tree(plantTree, best=8, FUN=prune.tree)
plot(pruneTree)
text(pruneTree, cex=0.8)

#setting up confusion matrix
plantConfuse<-data.frame(Obs=plantTest$common_garden,Pred=predict(pruneTree, plantTest, type="class"))
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

## Making a Decision tree with down sampling to account for fewer Vancouver samples
set.seed(100)
plantDecideQ2<-plantDecideQ[sample(nrow(plantDecideQ), 163),]

plantDecide2<-rbind(plantDecideQ2, plantDecideN, plantDecideV)

plantDecide2<-plantDecide2 %>%
  select(-c("Larg_Leaf_Len_Bolt", "Larg_Leaf_Wid_Bolt", "GM_StemHeight_Bolt", "GM_Leaf_Number_Bolt"))

plantDecide2$common_garden<-as.factor(plantDecide2$common_garden)

train2<-c(1:nrow(plantDecide2)) %% 2
plantTrain2<-plantDecide2[train2 == 1,]

test2<-1-train2
plantTest2<-plantDecide2[test2 == 1,]

plantTree2<-tree(common_garden ~ ., data=plantTrain2)

#plot the tree with text
plot(plantTree2) 
text(plantTree2, cex =0.8)

#prune nodes
pruneTree2<-cv.tree(plantTree2, best=8, FUN=prune.tree)
plot(pruneTree2)
text(pruneTree2, cex=0.8)

#setting up confusion matrix
plantConfuse2<-data.frame(Obs=plantTest2$common_garden,Pred=predict(pruneTree2, plantTest2, type="class"))
table(plantConfuse2)

#calculating the misclassification rate 
MisClass2<-plantConfuse2 %>%
  filter(Obs!=Pred)
nrow(MisClass2)/nrow(plantConfuse2)

#checking that misclass and correct class = 1
correct2<-plantConfuse2 %>%
  filter(Obs==Pred)
nrow(correct2)/nrow(plantConfuse2)

## Making a Decision Tree with only plants that survived (mortality = 1) without down sampling
plantDecide3<-subset(plantDecide_raw, mortality == 1)

plantDecideQ_3<-subset(plantDecide3, common_garden == "Q")
plantDecideN_3<-subset(plantDecide3, common_garden == "N")
plantDecideV_3<-subset(plantDecide3, common_garden == "V")

plantDecide3<-rbind(plantDecideQ_3, plantDecideN_3, plantDecideV_3)

plantDecide3$common_garden<-as.factor(plantDecide3$common_garden)

plantTemp2<- plantDecide3 %>%
  select(-c("common_garden", "mortality"))

plantTemp2$Larg_Leaf_Len_Bolt <- as.numeric(plantTemp2$Larg_Leaf_Len_Bolt)
plantTemp2$Larg_Leaf_Wid_Bolt <- as.numeric(plantTemp2$Larg_Leaf_Wid_Bolt)
plantTemp2$GM_StemHeight_Bolt <- as.numeric(plantTemp2$GM_StemHeight_Bolt)
plantTemp2$GM_Leaf_Number_Bolt <- as.numeric(plantTemp2$GM_Leaf_Number_Bolt)

str(plantTemp2)

plant_matrix2<-as.matrix(plantTemp2)

plantDecide3<- plantDecide3 %>%
  select(-mortality)

train3<-c(1:nrow(plantDecide3)) %% 2
plantTrain3<-plantDecide3[train3 == 1,]

test3<-1-train3
plantTest3<-plantDecide3[test3 == 1,]

plantTree3<- tree(common_garden ~ ., data=plantTrain3)

#plot the tree with text
plot(plantTree3) 
text(plantTree3, cex =0.8)

#prune nodes
pruneTree3<-cv.tree(plantTree3, best=8, FUN=prune.tree)
plot(pruneTree3)
text(pruneTree3, cex=0.8)

#setting up confusion matrix
plantConfuse3<-data.frame(Obs=plantTest3$common_garden,Pred=predict(pruneTree3, plantTest3, type="class"))
table(plantConfuse3)

#calculating the misclassification rate 
MisClass3<-plantConfuse3 %>%
  filter(Obs!=Pred)
nrow(MisClass3)/nrow(plantConfuse3)

#checking that misclass and correct class = 1
correct3<-plantConfuse3 %>%
  filter(Obs==Pred)
nrow(correct3)/nrow(plantConfuse3)

## Making a Decision tree with down sampling to account for mortality == 1
set.seed(100)
plantDecideQ_4<-plantDecideQ_3[sample(nrow(plantDecideQ_3), 38),]

plantDecide4<-rbind(plantDecideQ_4, plantDecideN_3, plantDecideV_3)

plantDecide4$common_garden<-as.factor(plantDecide4$common_garden)

plantDecide4<- plantDecide4 %>%
  select(-mortality)

train4<-c(1:nrow(plantDecide4)) %% 2
plantTrain4<-plantDecide4[train4 == 1,]

test4<-1-train4
plantTest4<-plantDecide4[test4 == 1,]

plantTree4<- tree(common_garden ~ ., data=plantTrain4)

#plot the tree with text
plot(plantTree4) 
text(plantTree4, cex =0.8)

#setting up confusion matrix
plantConfuse4<-data.frame(Obs=plantTest4$common_garden,Pred=predict(plantTree4, plantTest4, type="class"))
table(plantConfuse4)

#calculating the misclassification rate 
MisClass4<-plantConfuse4 %>%
  filter(Obs!=Pred)
nrow(MisClass4)/nrow(plantConfuse4)

#checking that misclass and correct class = 1
correct4<-plantConfuse4 %>%
  filter(Obs==Pred)
nrow(correct4)/nrow(plantConfuse4)
