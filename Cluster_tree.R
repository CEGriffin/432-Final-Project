#Create cluster tree to asses whether plants
#group by common garden or population

#set working directory
getwd()
setwd("C:/Users/clari/Desktop/BIOL 432/Week10/432-Final-Project")

#load libraries
library(ggplot2)
library(ape)
library(reshape2)
library(viridis)
library(dplyr)
library(ggtree)

#load data
data<-read.csv("./normalized_data.csv")
head(data)

#See if plants cluster by common garden or genetic population or neither
#group by similarities in growth rate

#make a dataframe with only the important columns
data2<-data%>%
  select(starts_with("z_"))
head(data2)

#make a distance matrix - this is a linear matrix
distance<-dist(data2)
head(distance)

#tree building
tree1<-nj(distance)
str(tree1)
ggtree(tree1, layout="rectangular") +
  geom_tiplab()

#colour by common garden or population
ggtree(tree1, layout="rectangular") %<+% data +
  geom_tiplab(aes(colour="common_garden")) +
  theme(legend.position="right")

head(data)



#normalixze all the data
#regression trees- you can combo diff kinds of data
#for clustering use only the the same type of data
#check normality
#correlation structure- eg chlor a and b
#do a pca - take only pci, which represents chemistry , relative growth rates
#log transform counts- will approx normalize it


#try to colour by population or common garden
#will ask colautti abou tthis


#use a diff object for labelling, wird pipe %>+%

#pca normalzed, 
#not decision tree, can use raw data on that


#YOU CAN PROBABLY IGNORE THIS

#turn into a matrix
dist_matr<-as.matrix(distance)
pdat<-melt(dist_matr)
head(pdat)
names(pdat)<-c("query", "subject", "distance")
dim(dist_matr)
dim(pdat)
str(pdat)

#visualize distance matrix
ggplot(data=pdat, aes(x=query, y=subject, fill=distance)) +
  geom_tile()
#i think this is too big to visualize