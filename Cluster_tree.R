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
data<-read.csv("./DataSynth_expand_tag.csv")
head(data)

#See if plants cluster by common garden or genetic population or neither
#group by similarities in growth rate

#which variables to use for growth rate/survival? - only in the green house
#Relative growth rate 1-4
#chlorophyl A and B concentration
#gluc_cong, flav_conc
#leaf len and width and total area
#all bolt stuff
#all gm leaf dimensions
#mortality


#make a dataframe with only the important columns
data2<-data%>%
  select("RGR1", "RGR2", "RGR3", "RGR4", "ChlorA", "ChlorB",
         "gluc_Conc", "flav_Conc", "GM_Leaf_Wid", "GM_Leaf_Len",
         "GM_TotalLeaf_Area", "GM_NumberOfLeaves", "mortality")
View(data2)

#male a distance matrix - this is a linear matrix
distance<-dist(data2)
head(distance)
dim(distance)

#turn into a matrix- then do some more strange transformations???
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
#i think this is too big to visualize- it keeps crashing- also uninterpretable

#tree building
tree1<-nj(distance)
ggtree(tree1, layout="rectangular", ignore.negative.edge=TRUE)
#has negative edge lengths??
#something is wrong with this tree

#try to colour by population or common garden
#will ask colautti abou tthis
