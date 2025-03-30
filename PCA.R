library(dplyr)

#loading in the scaled and normalized data 
plantData<-read.table("https://raw.githubusercontent.com/CEGriffin/432-Final-Project/main/normalized_data.csv", 
                      header=T, sep="," )

head(plantData)

#plantData<-subset(plantData, mortality == 1)

plantDataQ<-subset(plantData, common_garden == "Q")
plantDataN<-subset(plantData, common_garden == "N")
plantDataV<-subset(plantData, common_garden == "V")

pcaData<-rbind(plantDataQ, plantDataN, plantDataV)

pcaData<-pcaData %>%
  select(-c("Tag", "petri_dish", "population", "family", "ID",
            "gh_bench", "gh_col", "gh_row", "Row_Field", "Col_Field", "common_garden"))

plantPCA<-princomp(na.omit(pcaData),cor=F)

#checking the PCA output and its structure
str(plantPCA)
head(plantPCA)
names(plantPCA)

library(ggplot2)

PCloadings<-data.frame(Component=c(1:13),Eigenvalue=plantPCA$sdev^2)

#scree plot - elbow is around 5.0 principal components
ggplot(aes(x=Component,y=Eigenvalue),data=PCloadings) +geom_point() + geom_line()

#what are the loadings of ea. var on the components 
plantPCA$loadings

#combining the PCA with the original plant data for graphing 
plantCombined<-cbind(na.omit(pcaData), plantPCA$scores)

plantCombined<-plantCombined %>% 
  rename(PC1 = Comp.1, PC2 = Comp.2, PC3 = Comp.3, PC4= Comp.4, PC5 = Comp.5)

str(plantCombined)

plantCombined$population<-as.factor(plantCombined$population)

#creating the bivariate plots for PC1 vs PC2 
ggplot(aes(x=PC1,y=PC2,colour=population, shape=common_garden),data=plantCombined)+
  geom_point() + theme_bw()

ggplot(aes(x=PC2,y=PC3,colour=population, shape=common_garden),data=plantCombined)+
  geom_point() + theme_bw()

#ggplot(aes(x=PC3,y=PC4,colour=population, shape=common_garden),data=plantCombined)+
  #geom_point()+ theme_bw()

#ggplot(aes(x=PC4,y=PC5,colour=population, shape=common_garden),data=plantCombined)+
  #geom_point()+ theme_bw()


#checking if the bolt only data exhibits the same trend 

boltData<-read.table("https://raw.githubusercontent.com/CEGriffin/432-Final-Project/main/normalized_bolt_data.csv", 
                      header=T, sep="," )

head(boltData)

boltData2<-cbind(boltData, common_garden= plantData$common_garden)

pcaData2<-boltData2 %>%
  select(-c("Tag", "petri_dish", "population", "family", "ID",
            "gh_bench", "gh_col", "gh_row", "Row_Field", "Col_Field", 
            "common_garden"))

boltPCA<-princomp(pcaData2,cor=F)

#checking the PCA output and its structure
str(boltPCA)
head(boltPCA)
names(boltPCA)

PCloadings2<-data.frame(Component=c(1:17),Eigenvalue=boltPCA$sdev^2)

#scree plot - elbow is around 5.0 principal components
ggplot(aes(x=Component,y=Eigenvalue),data=PCloadings2) +geom_point() + geom_line()

#what are the loadings of ea. var on the components 
boltPCA$loadings

#combining the PCA with the original plant data for graphing 
boltCombined<-cbind(boltData2, boltPCA$scores)

boltCombined<-boltCombined %>% 
  rename(PC1 = Comp.1, PC2 = Comp.2, PC3 = Comp.3, PC4= Comp.4, PC5 = Comp.5, 
         PC6=Comp.6)

str(boltCombined)

## is there a reason the plantData does not have common garden?

boltCombined$population<-as.factor(boltCombined$population)

#creating the bivariate plots for PC1 vs PC2 
ggplot(aes(x=PC1,y=PC2,colour=population, shape=common_garden),data=boltCombined)+
  geom_point()+ theme_bw() 

ggplot(aes(x=PC2,y=PC3,colour=population, shape=common_garden),data=boltCombined)+
  geom_point()+ theme_bw()

ggplot(aes(x=PC3,y=PC4,colour=population, shape=common_garden),data=boltCombined)+
  geom_point()+ theme_bw()

ggplot(aes(x=PC4,y=PC5,colour=population, shape=common_garden),data=boltCombined)+
  geom_point()+ theme_bw()

ggplot(aes(x=PC5,y=PC6,colour=population, shape=common_garden),data=boltCombined)+
  geom_point()+ theme_bw()

