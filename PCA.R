library(dplyr)

#loading in the scaled and normalized data 
plantData<-read.table("https://raw.githubusercontent.com/CEGriffin/432-Final-Project/main/normalized_data.csv", 
                      header=T, sep="," )

head(plantData)

plantData<-subset(plantData, mortality == 1)

pcaData<-plantData %>%
  select(-c("Tag", "petri_dish", "population", "family", "ID",
            "gh_bench", "gh_col", "gh_row", "Row_Field", "Col_Field", "mortality"))

plantPCA<-princomp(pcaData,cor=F)

#checking the PCA output and its structure
str(plantPCA)
head(plantPCA)
names(plantPCA)

library(ggplot2)

PCloadings<-data.frame(Component=c(1:12),Eigenvalue=plantPCA$sdev^2)

#scree plot - elbow is around 5.0 principal components
ggplot(aes(x=Component,y=Eigenvalue),data=PCloadings) +geom_point() + geom_line()

#what are the loadings of ea. var on the components 
plantPCA$loadings

#combining the PCA with the original plant data for graphing 
plantCombined<-cbind(plantData, plantPCA$scores)

plantCombined<-plantCombined %>% 
  rename(PC1 = Comp.1, PC2 = Comp.2, PC3 = Comp.3, PC4= Comp.4, PC5 = Comp.5)

str(plantCombined)

## is there a reason the plantData does not have common garden?

plantCombined$population<-as.factor(plantCombined$population)

#creating the bivariate plots for PC1 vs PC2 
ggplot(aes(x=PC1,y=PC2,colour=population),data=plantCombined)+
  geom_point()

#ggplot(aes(x=PC1,y=PC2,colour=population, shape=common_garden),data=plantCombined)+
  #geom_point()







